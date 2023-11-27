#include <iostream>

#include <CL/sycl.hpp>

//namespace sycl = cl::sycl;

int main(int, char **) {
  //<<Setup host storage>>
  sycl::float4 a = {1.0, 2.0, 3.0, 4.0};
  sycl::float4 b = {4.0, 3.0, 2.0, 1.0};
  sycl::float4 c = {0.0, 0.0, 0.0, 0.0};

  //<<Initialize device selector>>
  sycl::default_selector device_selector;

  //<<Initialize queue>>
  sycl::queue queue(device_selector);
  std::cout << "Running on "
            << queue.get_device().get_info<sycl::info::device::name>() << "\n";

  {
    //<<Setup device storage>>
    { // start of scope, ensures data copied back to host
      sycl::buffer<sycl::float4, 1> a_sycl(&a, sycl::range<1>(1));
      sycl::buffer<sycl::float4, 1> b_sycl(&b, sycl::range<1>(1));
      sycl::buffer<sycl::float4, 1> c_sycl(&c, sycl::range<1>(1));
      //<<Execute kernel>>
      queue.submit([&](sycl::handler &cgh) {
        auto a_acc = a_sycl.get_access<sycl::access::mode::read>(cgh);
        auto b_acc = b_sycl.get_access<sycl::access::mode::read>(cgh);
        auto c_acc = c_sycl.get_access<sycl::access::mode::discard_write>(cgh);

        cgh.single_task<class vector_addition>(
            [=]() { c_acc[0] = a_acc[0] + b_acc[0]; });
      });
    } // end of scope, ensures data copied back to host
  }

  //<<Print results>>
  std::cout << "  A { " << a.x() << ", " << a.y() << ", " << a.z() << ", "
            << a.w() << " }\n"
            << "+ B { " << b.x() << ", " << b.y() << ", " << b.z() << ", "
            << b.w() << " }\n"
            << "------------------\n"
            << "= C { " << c.x() << ", " << c.y() << ", " << c.z() << ", "
            << c.w() << " }" << std::endl;

  return 0;
}
