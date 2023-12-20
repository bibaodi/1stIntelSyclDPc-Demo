#include <sycl/sycl.hpp>
/*https://registry.khronos.org/SYCL/specs/sycl-2020/html/sycl-2020.html#_device_information_descriptors*/

using namespace sycl;
int main() {
  for (auto platform : sycl::platform::get_platforms()) {
    std::cout << "Platform: " << platform.get_info<sycl::info::platform::name>()
              << std::endl;

    for (auto device : platform.get_devices()) {
      std::cout << "\tDevice: " << device.get_info<sycl::info::device::name>()
                << std::endl;
      printf("\tmax compute unites=%d \n",device.get_info<sycl::info::device::max_compute_units>());
      printf("\tdevice_type=%llu \n",device.get_info<sycl::info::device::device_type>());
      printf("\tglobal_mem_size=%lu MBytes\n",device.get_info<sycl::info::device::global_mem_size>()/1024/1024);
      printf("\tprofile=%s\n",device.get_info<sycl::info::device::profile>().c_str());
      printf("\tversion=%s\n",device.get_info<sycl::info::device::version>().c_str());
      printf("\tbackend_version=%s, driver_version=%s\n",device.get_info<sycl::info::device::backend_version>().c_str(), device.get_info<sycl::info::device::driver_version>().c_str() );
    }
  }
}
