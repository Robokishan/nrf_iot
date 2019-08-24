# NRF52840

![N|Solid](https://www.nordicsemi.com/-/media/Images/News/2017/Product-news/Q3/thread-nRF52840-logo-library.jpg?h=1000&la=en&w=1376&hash=CF8910E1246DA913447D24696171FFA5F0309EF5)

![](https://github.com/openthread/openthread)

It is based on nrf52840 thread device and [openthread](https://github.com/openthread/openthread) library is used.

# Project structure
  - include (user application libraries)
  - lib     (system libraries)
  - src     (main source)
  - third_party -> source1 -> source_code (thirdparty libraries)
                -> source2 -> source_code
                

# 1.Install adafruit-nrfutil from pip
`$ pip3 install --user adafruit-nrfutil`
# 2.Install nrfutil
`pip install nrfutil`
# 3.Update submodules
`git submodule update --init --recursive`
# 4.Make submodule
`cd custom-baud ; make`
# 5.Make
`make clean ; make all`
