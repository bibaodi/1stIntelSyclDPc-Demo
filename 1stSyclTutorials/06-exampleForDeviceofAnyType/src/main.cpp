#include <CL/sycl.hpp>
#include <iostream>
#include <unistd.h>
#include <sycl/ext/intel/fpga_extensions.hpp>

using namespace sycl;
#include <oneapi/dpl/execution>
auto exception_handler = [](sycl::exception_list exceptions) {
  for (std::exception_ptr const &e : exceptions) {
    try {
      std::rethrow_exception(e);
    } catch (sycl::exception const &e) {
      std::cout << "Caught asynchronous SYCL exception:\n"
                << e.what() << std::endl;
    }
  }
};

void output_dev_info(const device &dev, const std::string &selector_name) {
  std::cout << selector_name
            << ": Selected device: " << dev.get_info<info::device::name>()
            << "\n";
  std::cout << "->Device vendor : "
            << dev.get_info<info::device::vendor>() << "\n";
}

int main(int argc, char **argv) {
  int N = 10;
  std::cout << "default QueueConstruct=============================\n\n";
  for (int i = 0; i < N; i++) {
    sycl::queue q;
    std::cout << "Selected device: "
              << q.get_device().get_info<sycl::info::device::name>() << "\n";
  }

  std::cout << "\nselector=============================\n\n";
  queue q{cpu_selector_v};
  std::cout << "Selected device: "
            << q.get_device().get_info<info::device::name>() << "\n";
  std::cout << " -> Device vendor: "
            << q.get_device().get_info<info::device::vendor>() << "\n";

try {
  output_dev_info(device{default_selector_v}, "default_selector_v");
  output_dev_info(device{cpu_selector_v}, "cpu_selector_v");
  output_dev_info(device{gpu_selector_v}, "gpu_selector_v");
  output_dev_info(device{accelerator_selector_v}, "accelerator_selector_v");
  output_dev_info(device{ext::intel::fpga_selector_v}, "fpga_selector_v");
} catch(std::exception &e) {
	std::cerr<<"Exception Found:\n";
	std::cerr<<e.what();
	std::cerr<<"\nExceptionEnd.\n";
} 
  return 0;
}
