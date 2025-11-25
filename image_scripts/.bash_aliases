# Aliases for interacting with ROS1 environment

# --- ROS Networking ---
function set_ros_master() {
    # Set port to $2 if provided, otherwise default to 11311
    local port=${2:-11311}

    if [ -z "$1" ]; then
        echo "Usage: set_ros_master <hostname_or_ip> [port]"
        echo "Example: set_ros_master my_robot.local 11311"
        echo "Setting to localhost (default)"
        export ROS_MASTER_URI=http://localhost:11311
    else
        export ROS_MASTER_URI=http://$1:$port
        echo "ROS_MASTER_URI set to: $ROS_MASTER_URI"
        echo "ROS_IP set to:         $ROS_IP"
    fi
}

# --- Rviz with Namespace ---
function rviz_namespaced() {
    local config_file="$1"
    local ns="$2"

    if [ -z "$config_file" ] || [ -z "$ns" ]; then
        echo "Usage: rviz_namespaced <path_to_config.rviz> <namespace>"
        echo "Example: rviz_namespaced /path/to/my_config.rviz robot1"
        return 1
    fi

    # Check if the config file exists
    if [ ! -f "$config_file" ]; then
        echo "Error: Config file not found: $config_file"
        return 1
    fi

    # Clean the namespace: remove leading/trailing slashes
    local clean_ns
    clean_ns=$(echo "$ns" | sed 's:^/*::' | sed 's:/*$::')

    if [ -z "$clean_ns" ]; then
         echo "Error: Invalid namespace provided."
         return 1
    fi

    echo "Loading Rviz config: $config_file"
    echo "Remapping TF to namespace: /$clean_ns"

    # Launch rviz with the config and remappings
    rviz -d "$config_file" tf:=/"$clean_ns"/tf tf_static:=/"$clean_ns"/tf_static
}

# --- RQT with Namespace ---
function rqt_namespaced() {
    if [ -z "$1" ]; then
        echo "Usage: rqt_namespaced <namespace>"
        echo "Example: rqt_namespaced /robot1"
        return 1
    fi

    echo "Launching RQT in namespace: $1"
    ROS_NAMESPACE=$1 rqt
}

function kill_sim() {
    echo "Sending SIGTERM to gzserver, gzclient, and rosmaster..."
    pkill -f gzserver
    pkill -f gzclient
    pkill -f rosmaster
    echo "Done."
}

function killgazeboros() {
    pkill -e -f gazebo | pkill -e -f ros
}

# --- Isolated Build (Release) ---
function build_release() {
    if [ -z "$1" ]; then
        echo "Usage: build_iso_release <pkg1> [pkg2 …]"
        return 1
    fi
    echo "==> Isolated Release build for: $@"
    catkin_make_isolated \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCMAKE_BUILD_TYPE=Release \
        --install --only-pkg-with-deps \
        "$@"
}

# --- Isolated Build (Debug) ---
function build_debug() {
    if [ -z "$1" ]; then
        echo "Usage: build_iso_debug <pkg1> [pkg2 …]"
        return 1
    fi
    echo "==> Isolated Debug build for: $@"
    catkin_make_isolated \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCMAKE_BUILD_TYPE=Debug \
        --install --only-pkg-with-deps \
        "$@"
}

# --- Compile Commands Database ---
function gen_compile_db() {
    # Check if build_isolated exists
    if [ ! -d "build_isolated" ]; then
        echo "Error: 'build_isolated' directory not found. Did you build anything?"
        return 1
    fi

    echo "Finding and merging compile_commands.json files..."

    # Run the find/cat/jq pipeline
    find build_isolated -name compile_commands.json -exec cat {} + \
      | jq -s 'add' > compile_commands.json

    if [ $? -ne 0 ]; then
        echo "Error: 'find' or 'jq' command failed. Do you have 'jq' installed?"
        return 1
    fi

    local entries
    entries=$(jq 'length' compile_commands.json)

    echo "Success! Generated compile_commands.json with $entries entries."
}


