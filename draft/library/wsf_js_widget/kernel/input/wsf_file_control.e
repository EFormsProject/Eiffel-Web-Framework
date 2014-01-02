note
	description: "Summary description for {WSF_FILE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_CONTROL

inherit

	WSF_VALUE_CONTROL [detachable WSF_FILE]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_value_control ("input")
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		local
			id: detachable STRING
		do
			if attached {JSON_STRING} new_state.item ("file_name") as new_name and attached {JSON_STRING} new_state.item ("file_type") as new_type and attached {JSON_NUMBER} new_state.item ("file_size") as new_size then
				if attached {JSON_STRING} new_state.item ("file_id") as a_id then
					id := a_id.unescaped_string_32
				end
				create file.make (new_name.unescaped_string_32, new_type.unescaped_string_32, new_size.item.to_integer_32, id);
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put_boolean (attached change_event, "callback_change")
			Result.put_boolean (attached upload_done_event, "callback_uploaddone")
			if attached file as f then
				Result.put_string (f.name, "file_name")
				Result.put_string (f.type, "file_type")
				Result.put_integer (f.size, "file_size")
				Result.put_string (f.id, "file_id")
			end
			Result.put_boolean (disabled, "disabled")
		end

feature -- Event handling

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable ANY)
		local
			f_name: detachable STRING
			f_type: detachable STRING
			f_size: detachable INTEGER
			f_id: detachable STRING
		do
			if Current.control_name.same_string (cname [1]) then
				if attached change_event as cevent and event.same_string ("change") then
					cevent.call (Void)
				elseif attached upload_done_event as udevent and event.same_string ("uploaddone") then
					udevent.call (Void)
				elseif event.same_string ("uploadfile") and attached {ITERABLE [WSF_UPLOADED_FILE]} event_parameter as files then
					if attached file as f then
						if attached upload_function as ufunction then
							f.set_id (ufunction.item ([files]))
						end
						f_name := f.name
						f_type := f.type
						f_size := f.size
						f_id := f.id
					end
					state_changes.replace_with_string (f_name, "file_name")
					state_changes.replace_with_string (f_type, "file_type")
					state_changes.replace_with_integer (f_size, "file_size")
					state_changes.replace_with_string (f_id, "file_id")
				end
			end
		end

feature -- Upload

	start_upload
		local
			upload: WSF_JSON_OBJECT
		do
			create upload.make
			upload.put_string ("start_upload", "type")
			actions.add (upload)
		end

feature -- Implementation

	value: detachable WSF_FILE
		do
			Result := file
		end

	render: STRING
		local
			attr: STRING
		do
			attr := "type=%"file%"  "
			if attached attributes as a then
				attr.append (a)
			end
			if disabled then
				attr.append ("disabled=%"disabled%" ")
			end
			Result := render_tag ("", attr)
		end

feature -- Change

	set_change_event (e: attached like change_event)
			-- Set text change event handle
		do
			change_event := e
		end

	set_upload_done_event (e: attached like upload_done_event)
			-- Set text change event handle
		do
			upload_done_event := e
		end

	set_upload_function (e: attached like upload_function)
			-- Set button click event handle
		do
			upload_function := e
		end

	set_disabled (b: BOOLEAN)
		do
			if disabled /= b then
				disabled := b
				state_changes.replace_with_boolean (disabled, "disabled")
			end
		end

feature -- Properties

	disabled: BOOLEAN
			-- Defines if the a file is selectable and if a file can be removed once it is uploaded

	file: detachable WSF_FILE
			-- Text to be displayed

	change_event: detachable PROCEDURE [ANY, TUPLE]
			-- Procedure to be execued on change

	upload_done_event: detachable PROCEDURE [ANY, TUPLE]
			-- Procedure to be execued when upload was successful

	upload_function: detachable FUNCTION [ANY, TUPLE [ITERABLE [WSF_UPLOADED_FILE]], detachable STRING]
			-- Store uploaded file and return server side file id

end
