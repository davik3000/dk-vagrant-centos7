#!/bin/bash

update_yum() {
  echo "> yum: update"
  sudo yum update -y -q
}

install_xfce() {
  echo "> yum: install epel-release"
  sudo yum install -y -q epel-release
  
  echo "> yum: install 'Server with GUI'"
  sudo yum groups install -y -q "Server with GUI"
  
  echo "> yum: install Xfce"
  sudo yum groups install -y -q "Xfce"
}

enable_sys_graphic() {
  systemctl set-default graphical.target
}

enable_xfce_session() {
  echo "> enabling Xfce session"
  
  EXEC_XFCE_SESSION="exec /usr/bin/xfce4-session"
  XINITRC_PATH=/root/.xinitrc
  XFCE_EXIST=
  
  if [ -f ${XINITRC_PATH} ] ; then
    echo " > detected xinitrc"
    XFCE_EXIST=$(grep -ce '^exec.*xfce4-session$' ${XINITRC_PATH})
  fi;
  
  if [ -eq ${XFCE_EXIST} 1 ] ; then
    echo ${EXEC_XFCE_SESSION} >> ${XINITRC_PATH}
  fi;
  
  sudo sed -i 's#allowed_users=.*$#allowed_users=anybody#' /etc/X11/Xwrapper.config
}

update_yum
install_xfce
enable_sys_graphic
