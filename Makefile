all: $(BINDIR)/micro_ros.a

clean:
	rm -rf $(BINDIR)/micro_ros.a
	rm -rf $(BINDIR)/include
	rm -rf $(PKG_SOURCE_DIR)/micro_ros_dev
	rm -rf $(PKG_SOURCE_DIR)/micro_ros_src
	rm -rf $(PKG_BUILD_DIR)/colcon_venv

$(PKG_BUILD_DIR)/colcon_venv:
	@python3 -m venv $(PKG_BUILD_DIR)/colcon_venv; \
	$(PKG_BUILD_DIR)/colcon_venv/bin/pip install -U colcon-common-extensions lark;

$(PKG_BUILD_DIR)/configured_colcon.meta:
	@cp -f $(PKG_SOURCE_DIR)/colcon.meta $(PKG_BUILD_DIR)/configured_colcon.meta; \
	if [ -f $(PKG_SOURCE_DIR)/kconfig_vars ]; then \
		. $(PKG_SOURCE_DIR)/kconfig_vars; \
		sed -i 's/\(RMW_UXRCE_MAX_NODES=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_NODES"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_SUBSCRIPTIONS=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_SUBSCRIPTIONS"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_PUBLISHERS=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_PUBLISHERS"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_HISTORY=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_HISTORY"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_SERVICES=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_SERVICES"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_CLIENTS=\)[0-9]*/\1'"$$CONFIG_MICRO_ROS_MAX_CLIENTS"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_MAX_HISTORY=\)[0-9]*/\1'"$$MICRO_ROS_MAX_HISTORY"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_STREAM_HISTORY_INPUT=\)[0-9]*/\1'"$$MICRO_ROS_STREAM_HISTORY_INPUT"'/g' $@; \
		sed -i 's/\(RMW_UXRCE_STREAM_HISTORY_OUTPUT=\)[0-9]*/\1'"$$MICRO_ROS_STREAM_HISTORY_OUTPUT"'/g' $@; \
	fi

$(PKG_BUILD_DIR)/micro_ros_dev/install: $(PKG_BUILD_DIR)/colcon_venv
	@rm -rf $(PKG_SOURCE_DIR)/micro_ros_dev; \
	rm -rf $(PKG_BUILD_DIR)/micro_ros_dev/install; \
	mkdir $(PKG_SOURCE_DIR)/micro_ros_dev; cd $(PKG_SOURCE_DIR)/micro_ros_dev; \
	git clone -b kilted https://github.com/ament/ament_cmake src/ament_cmake; \
	git clone -b kilted https://github.com/ament/ament_lint src/ament_lint; \
	git clone -b kilted https://github.com/ament/ament_package src/ament_package; \
	git clone -b kilted https://github.com/ament/googletest src/googletest; \
	git clone -b kilted https://github.com/ros2/ament_cmake_ros src/ament_cmake_ros; \
	git clone -b kilted https://github.com/ament/ament_index src/ament_index; \
	touch src/ament_cmake_ros/rmw_test_fixture_implementation/COLCON_IGNORE; \
	touch src/ament_cmake_ros/rmw_test_fixture/COLCON_IGNORE; \
	. $(PKG_BUILD_DIR)/colcon_venv/bin/activate; \
	colcon build \
		--build-base $(PKG_BUILD_DIR)/micro_ros_dev/build \
		--install-base $(PKG_BUILD_DIR)/micro_ros_dev/install \
		--cmake-args \
		" -DBUILD_TESTING=OFF" \
		" -DCMAKE_TOOLCHAIN_FILE=$(PKG_BUILD_DIR)/toolchain_host.cmake" \
		2> $(PKG_BUILD_DIR)/dev_tools_errors.log

$(PKG_SOURCE_DIR)/micro_ros_src/src:
	@rm -rf $(PKG_SOURCE_DIR)/micro_ros_src; \
	mkdir $(PKG_SOURCE_DIR)/micro_ros_src; cd $(PKG_SOURCE_DIR)/micro_ros_src; \
	git clone -b ros2 https://github.com/eProsima/micro-CDR src/micro-CDR; \
	git clone -b ros2 https://github.com/eProsima/Micro-XRCE-DDS-Client src/Micro-XRCE-DDS-Client; \
	git clone -b kilted https://github.com/micro-ROS/rcl src/rcl; \
	git clone -b kilted https://github.com/ros2/rclc src/rclc; \
	git clone -b kilted https://github.com/micro-ROS/rcutils src/rcutils; \
	git clone -b kilted https://github.com/micro-ROS/micro_ros_msgs src/micro_ros_msgs; \
	git clone -b kilted https://github.com/micro-ROS/rmw-microxrcedds src/rmw-microxrcedds; \
	git clone -b kilted https://github.com/micro-ROS/rosidl_typesupport src/rosidl_typesupport; \
	git clone -b kilted https://github.com/micro-ROS/rosidl_typesupport_microxrcedds src/rosidl_typesupport_microxrcedds; \
	git clone -b kilted https://github.com/ros2/rosidl src/rosidl; \
	git clone -b kilted https://github.com/ros2/rosidl_dynamic_typesupport src/rosidl_dynamic_typesupport; \
	git clone -b kilted https://github.com/ros2/rmw src/rmw; \
	git clone -b kilted https://github.com/ros2/rcl_interfaces src/rcl_interfaces; \
	git clone -b kilted https://github.com/ros2/rosidl_defaults src/rosidl_defaults; \
	git clone -b kilted https://github.com/ros2/unique_identifier_msgs src/unique_identifier_msgs; \
	git clone -b kilted https://github.com/ros2/common_interfaces src/common_interfaces; \
	git clone -b kilted https://github.com/ros2/test_interface_files src/test_interface_files; \
	git clone -b kilted https://github.com/ros2/rmw_implementation src/rmw_implementation; \
	git clone -b kilted https://github.com/ros2/rcl_logging src/rcl_logging; \
	git clone -b kilted https://github.com/ros2/ros2_tracing src/ros2_tracing; \
	git clone -b kilted https://github.com/micro-ROS/micro_ros_utilities src/micro_ros_utilities; \
	git clone -b kilted https://github.com/ros2/rosidl_core src/rosidl_core; \
	touch src/ros2_tracing/test_tracetools/COLCON_IGNORE; \
	touch src/ros2_tracing/lttngpy/COLCON_IGNORE; \
	touch src/rosidl/rosidl_typesupport_introspection_cpp/COLCON_IGNORE; \
	touch src/rclc/rclc_examples/COLCON_IGNORE; \
	touch src/common_interfaces/actionlib_msgs/COLCON_IGNORE; \
	touch src/common_interfaces/std_srvs/COLCON_IGNORE; \
	touch src/rcl/rcl_yaml_param_parser/COLCON_IGNORE; \
	touch src/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE; \
	touch src/rcl_interfaces/test_msgs/COLCON_IGNORE; \
	touch src/rmw/rmw_security_common/COLCON_IGNORE;

$(PKG_BUILD_DIR)/micro_ros/install: $(PKG_BUILD_DIR)/micro_ros_dev/install $(PKG_SOURCE_DIR)/micro_ros_src/src $(PKG_BUILD_DIR)/configured_colcon.meta
	@cd $(PKG_SOURCE_DIR)/micro_ros_src; \
	. $(PKG_BUILD_DIR)/colcon_venv/bin/activate; \
	. $(PKG_BUILD_DIR)/micro_ros_dev/install/local_setup.sh; \
	colcon build \
		--build-base $(PKG_BUILD_DIR)/micro_ros/build \
		--install-base $(PKG_BUILD_DIR)/micro_ros/install \
		--merge-install \
		--packages-ignore-regex=.*_cpp \
		--metas $(PKG_BUILD_DIR)/configured_colcon.meta \
		--cmake-args \
		" --no-warn-unused-cli" \
		" -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=OFF" \
		" -DTHIRDPARTY=ON" \
		" -DBUILD_SHARED_LIBS=OFF" \
		" -DBUILD_TESTING=OFF" \
		" -DCMAKE_BUILD_TYPE=Release" \
		" -DCMAKE_TOOLCHAIN_FILE=$(PKG_BUILD_DIR)/toolchain.cmake" \
		" -DCMAKE_VERBOSE_MAKEFILE=OFF" \
		2> $(PKG_BUILD_DIR)/micro_ros_errors.log

$(BINDIR)/micro_ros.a: $(PKG_BUILD_DIR)/micro_ros/install
	@mkdir -p $(PKG_BUILD_DIR)/micro_ros_o; cd $(PKG_BUILD_DIR)/micro_ros_o; \
	for file in $$(find $(PKG_BUILD_DIR)/micro_ros/install/lib/ -name '*.a'); do \
		folder=$$(echo $$file | sed -E "s/(.+)\/(.+).a/\2/"); \
		mkdir -p $$folder; cd $$folder; $(AR) x $$file; \
		for f in *; do \
			mv $$f ../$$folder-$$f; \
		done; \
		cd ..; rm -rf $$folder; \
	done ; \
	$(AR)  rc micro_ros.a *.obj; cp micro_ros.a $(BINDIR); ${RANLIB} $(BINDIR)/micro_ros.a; \
	cd ..; rm -rf micro_ros_o; \
	$(PKG_SOURCE_DIR)/flatten.sh $(PKG_BUILD_DIR)/micro_ros/install/include $(BINDIR)/include;

.PHONY: clean