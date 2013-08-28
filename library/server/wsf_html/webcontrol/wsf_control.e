note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

feature

	control_name: STRING

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
		-- Select state stored with `control_name` as key
		do
			if attached {JSON_OBJECT} new_states.item (create {JSON_STRING}.make_json (control_name)) as new_state_obj then
				set_state (new_state_obj)
			end
		end

	set_state (new_state: JSON_OBJECT)
		-- Before we process the callback. We restore the state of control.
		deferred
		end

	read_state (states: JSON_OBJECT)
		-- Add a new entry in the `states` JSON object with the `control_name` as key and the `state` as value
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
		end

	state: JSON_OBJECT
		-- Returns the current state of the Control as JSON. This state will be transfered to the client.
		deferred
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
		-- Method called if any callback recived. In this method you can route the callback to the event handler
		deferred
		end

feature

	render: STRING
		-- Return html representaion of control
		deferred
		end

end
