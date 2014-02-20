note
	description: "[
			Mutli controls are used as containers for multiple controls, for
			example a form is a multi control.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]

inherit

	WSF_MULTI_CONTROL [G]
		redefine
			add_control,
			set_control_name_prefix,
			handle_callback,
			set_control_id,
			render_tag
		end

create
	make_with_tag_name, make_tag_less

feature {NONE} -- Initialization

	make_tag_less
		do
			make_with_tag_name ("")
			stateless := True
		end

feature

	set_control_id (d: INTEGER)
		do
			control_id := d
			set_subcontrol_prefixes
		end

	set_control_name_prefix (p: STRING)
		do
			control_name_prefix := p
			set_subcontrol_prefixes
		end

	set_subcontrol_prefixes
		do
			across
				controls as e
			loop
				if attached {WSF_CONTROL} e.item as el then
					el.control_name_prefix := control_name_prefix + control_id.out + "_"
				end
			end
		end

feature

	add_control (c: G)
			-- Add a control to this multi control
		do
			controls.extend (c)
			if attached {WSF_CONTROL} c as d then
				d.control_id := controls.count
				d.control_name_prefix := control_name_prefix + control_id.out + "_"
			end
		end

	render_tag (body: STRING; attrs: detachable STRING): STRING
			-- Generate HTML of this control with the specified body and attributes
		local
			css_classes_string: STRING
		do
			create css_classes_string.make_empty
			across
				css_classes as c
			loop
				css_classes_string.append (" " + c.item)
			end
			Result := render_tag_with_tagname (tag_name, body, attrs, css_classes_string)
		end

feature -- Event handling

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable ANY)
			-- Pass callback to subcontrols
		do
			across
				controls as c
			until
				cname.is_empty
			loop
				if attached {WSF_CONTROL} c.item as cont then
					cont.handle_callback (cname, event, event_parameter)
				end
			end
		end

end
