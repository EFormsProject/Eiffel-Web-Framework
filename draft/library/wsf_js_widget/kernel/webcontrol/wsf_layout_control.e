note
	description: "Summary description for {WSF_LAYOUT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_LAYOUT_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control,
			add_control as add_control_raw
		end

create
	make

feature {NONE} -- Initialization

	make (n: STRING)
		do
			make_with_tag_name ("div")
			add_class ("row")
		end

feature -- Add control

	add_control_with_offset (c: WSF_STATELESS_CONTROL; span, offset: INTEGER)
		local
			div: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create div.make_with_tag_name ("div")
			div.add_class ("col-md-" + span.out + " col-md-offset-" + offset.out)
			div.add_control (c)
			add_control_raw (div)
		end

	add_control (c: WSF_STATELESS_CONTROL; span: INTEGER)
		local
			div: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create div.make_with_tag_name ("div")
			div.add_class ("col-md-" + span.out)
			div.add_control (c)
			add_control_raw (div)
		end

end
