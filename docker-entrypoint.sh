#!/bin/bash

if [ -n "$FTP_LIST" ]; then
	IFS=';' read -r -a parsed_ftp_list <<< "$FTP_LIST" ; unset IFS
	for ftp_account in ${parsed_ftp_list[@]}
	do
		IFS=':' read -r -a tab <<< "$ftp_account" ; unset IFS
		ftp_login=${tab[0]}
		ftp_pass=${tab[1]}
		CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $ftp_pass)
		mkdir /home/$ftp_login
		useradd --shell /bin/sh ${USERADD_OPTIONS} -d /home/$ftp_login --password $CRYPTED_PASSWORD $ftp_login
		chown -R $ftp_login:www-data /home/$ftp_login
	done
fi

exec "$@"
