#include <CL/sycl.hpp>
#include <iostream>
#include <unistd.h>

// namespace sycl = cl::sycl;
#include <oneapi/dpl/execution>

int dpl_main(){
    sycl::queue Q1(sycl::gpu_selector_v);
    auto gpu_policy = oneapi::dpl::execution::make_device_policy(Q1);

    std::cout << "GPU execution policy runs oneDPL functions on "
              << gpu_policy.queue().get_device().
                                    get_info<sycl::info::device::name>()
              << std::endl;

    sycl::queue Q2(sycl::cpu_selector_v);
    auto cpu_policy = oneapi::dpl::execution::make_device_policy(Q2);

    std::cout << "CPU execution policy runs oneDPL functions on "
              << cpu_policy.queue().get_device().
                                    get_info<sycl::info::device::name>()
              << std::endl;
}

inline void discoverDev(){
    sycl::queue Q(sycl::default_selector_v);
    std::cout << "Running on: "
              << Q.get_device().get_info<sycl::info::device::name>()
              << std::endl;
}

inline void showAllDev(){
  for (auto platform : sycl::platform::get_platforms())
    {
        std::cout << "Platform: "
                  << platform.get_info<sycl::info::platform::name>()
                  << std::endl;

        for (auto device : platform.get_devices())
        {
            std::cout << "\tDevice: "
                      << device.get_info<sycl::info::device::name>()
                      << std::endl;
        }
    }
}

int main(int, char **) {
  bool usingDaemon=false;
  dpl_main();
  showAllDev();
  
	discoverDev();
 

  pid_t pid = getpid();

  std::cout << "1:当前进程的PID是： " << pid << std::endl;
  int nochdir = 1, noclose = 1;
  if (usingDaemon && daemon(nochdir, noclose) < 0) {
    perror("error to daemon...\n");
    return -2;
  }

  pid = getpid();
  std::cout << "2:当前进程的PID是： " << pid << std::endl;
  std::cout << "running after daemon\n";
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

      cgh.single_task<struct vector_addition564>(
          [=]() { c_acc[0] = a_acc[0] + b_acc[0]; });
    });
  } // end of scope, ensures data copied back to host

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
