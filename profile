#!/bin/bash

export COMMON_PROCESSES=( "google-musicmanager" "dropbox" "kalu" "blueman-applet" )
export COMMON_SERVICES=( "bluetooth" )

export NETWORK_PROCESSES=( "nm-applet" )
export NETWORK_SERVICES=( "NetworkManager" )

export COMMON_RFKILLS=( "bluetooth" )
export NETWORK_RFKILLS=( "wifi" )

stop_services()
{
	declare service_name=
	for service_name in "${@}"; do
		sudo systemctl stop "${service_name}"
	done
}

rfkill_block()
{
	declare identifier=
	for identifier in "${@}"; do
		sudo rfkill block "${identifier}"
	done
}

kill_processes()
{
	declare process_name=
	for process_name in "${@}"; do
		pkill -f "${process_name}"
	done
}

other_stuff()
{
	sudo pkill -f "geoclue"
	pkill -9 "redshift"
}

profile_train()
{
	declare process_names=( "${COMMON_PROCESSES[@]}" "${NETWORK_PROCESSES[@]}" )
	kill_processes "${process_names[@]}"

	other_stuff

	declare service_names=( "${COMMON_SERVICES[@]}" "${NETWORK_SERVICES[@]}" )
	stop_services "${service_names[@]}"

	declare identifiers=( "${COMMON_RFKILLS[@]}" "${NETWORK_RFKILLS[@]}" )
	rfkill_block "${identifiers[@]}"
}

profile_train_except_network()
{
	kill_processes "${COMMON_PROCESSES[@]}"

	other_stuff

	stop_services "${COMMON_SERVICES[@]}"

	rfkill_block "${COMMON_RFKILLS[@]}"
}

main()
{
	"profile_${1}"
}

main "${@}"
