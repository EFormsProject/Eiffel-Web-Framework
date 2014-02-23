note
	description: "[
		Validator implementation which make sure that the uploaded file is smaller than x bytes
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILESIZE_VALIDATOR

inherit

	WSF_VALIDATOR [detachable WSF_FILE]
		rename
			make as make_validator
		redefine
			state
		end

create
	make

feature {NONE} -- Initialization

	make (m: INTEGER; e: STRING)
			-- Initialize with specified maximum filesize and error message which will be displayed on validation failure
		do
			make_validator (e)
			max := m
		end

feature -- Implementation

	is_valid (input: detachable WSF_FILE): BOOLEAN
		do
			Result := True
			if attached input as a_input then
				Result := a_input.size < max
			end
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			Result := Precursor
			Result.put_integer (max, "max")
		end

feature -- Properties

	max: INTEGER
			-- The maximal allowed value

end
