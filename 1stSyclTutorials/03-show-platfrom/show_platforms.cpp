#include <sycl/sycl.hpp>
#include <iostream>
#include <iomanip>
#include <ctime>
#include <sstream>
/*https://registry.khronos.org/SYCL/specs/sycl-2020/html/sycl-2020.html#_device_information_descriptors*/

#define PROP_NAME(_x) #_x
#define PRINT_DEVICE_PROPERTY(dev, prop) \
  std::cout <<"\t"<< PROP_NAME(prop) << ": " \
            << dev.get_info<sycl::info::device::prop>() << std::endl;

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
      printf("\tlocal_mem_size=%lu kBytes\n",device.get_info<sycl::info::device::local_mem_size>()/1024);
      printf("\timage_support=%d\n",device.get_info<sycl::info::device::image_support>());
      printf("\tmax_work_item_sizes=%d\n",device.get_info<sycl::info::device::max_work_item_sizes<1>>().get(0));
      printf("\tmax_work_item_sizes=[%d,%d,%d]\n",device.get_info<sycl::info::device::max_work_item_sizes<3>>().get(0),device.get_info<sycl::info::device::max_work_item_sizes<3>>().get(1),device.get_info<sycl::info::device::max_work_item_sizes<3>>().get(2));
      printf("\thost_unified_memory=%d\n",device.get_info<sycl::info::device::host_unified_memory>());
      printf("\tprofile=%s\n",device.get_info<sycl::info::device::profile>().c_str());
      printf("\tversion=%s\n",device.get_info<sycl::info::device::version>().c_str());
      printf("\tbackend_version=%s, driver_version=%s\n",device.get_info<sycl::info::device::backend_version>().c_str(), device.get_info<sycl::info::device::driver_version>().c_str() );

auto& dev = device;
        PRINT_DEVICE_PROPERTY(dev, name);
        PRINT_DEVICE_PROPERTY(dev, vendor);
        PRINT_DEVICE_PROPERTY(dev, driver_version);
        PRINT_DEVICE_PROPERTY(dev, profile);
        PRINT_DEVICE_PROPERTY(dev, version);
        PRINT_DEVICE_PROPERTY(dev, opencl_c_version);
        PRINT_DEVICE_PROPERTY(dev, max_compute_units);
        PRINT_DEVICE_PROPERTY(dev, max_work_item_dimensions);
        PRINT_DEVICE_PROPERTY(dev, max_work_group_size);
        PRINT_DEVICE_PROPERTY(dev, max_num_sub_groups);
        //PRINT_DEVICE_PROPERTY(dev, max_work_item_sizes<3>);
        PRINT_DEVICE_PROPERTY(dev, preferred_vector_width_short);
        PRINT_DEVICE_PROPERTY(dev, preferred_vector_width_int);
        PRINT_DEVICE_PROPERTY(dev, preferred_vector_width_double);
        PRINT_DEVICE_PROPERTY(dev, preferred_vector_width_half);
        PRINT_DEVICE_PROPERTY(dev, native_vector_width_char);
        PRINT_DEVICE_PROPERTY(dev, native_vector_width_int);
        PRINT_DEVICE_PROPERTY(dev, native_vector_width_float);
        PRINT_DEVICE_PROPERTY(dev, native_vector_width_double);
        PRINT_DEVICE_PROPERTY(dev, native_vector_width_half);
        PRINT_DEVICE_PROPERTY(dev, local_mem_size);
        PRINT_DEVICE_PROPERTY(dev, global_mem_cache_line_size);
        PRINT_DEVICE_PROPERTY(dev, global_mem_cache_size);
        PRINT_DEVICE_PROPERTY(dev, global_mem_size);
        PRINT_DEVICE_PROPERTY(dev, max_constant_buffer_size);
        PRINT_DEVICE_PROPERTY(dev, max_constant_args);
    }
  }


{
    std::time_t t = std::time(nullptr);
    std::tm* local_time = std::localtime(&t);

    std::stringstream ss;
    ss << std::put_time(local_time, "%Y%m%dT%H%M%S");

    std::string formatted_time = ss.str();
    std::cout << "格式化后的日期时间字符串： " << formatted_time << std::endl;

    return 0;
}

}
