note
	description: "Summary description for {WSF_IMAGE_SLIDER_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SLIDER_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize with specified name
		do
			make_control ( "div")
			add_class ("carousel slide")
			create list.make_with_tag_name ( "ol")
			list.add_class ("carousel-indicators")
			create slide_wrapper.make_with_tag_name ("div")
			slide_wrapper.add_class ("carousel-inner")
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		do
		end

	state: WSF_JSON_OBJECT
		do
			create Result.make
		end

feature -- Callback

	handle_callback (cname: LIST[STRING_32]; event: STRING_32; event_parameter: detachable ANY)
		do
				-- Do nothing here
		end

feature -- Rendering

	render: STRING_32
		local
			temp: STRING_32
		do
			temp := list.render
			temp.append (slide_wrapper.render)
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-prev%"></span>", "data-slide=%"prev%"", "left carousel-control"))
			temp.append (render_tag_with_tagname ("a", "<span class=%"icon-next%"></span>", "data-slide=%"next%"", "right carousel-control"))
			Result := render_tag (temp, "")
		end

feature -- Change

	add_image_with_caption (src, alt, caption: STRING_32)
		local
			caption_control: detachable WSF_STATELESS_CONTROL
		do
			if attached caption as c and then not c.is_empty then
				caption_control := create {WSF_BASIC_CONTROL}.make_with_body ("p", "", c)
			end
			add_image_with_caption_control (src, alt, caption_control)
		end

	add_image_with_caption_control (src, alt: STRING_32; caption: detachable WSF_STATELESS_CONTROL)
			-- Add a new image to the slider, with specified url, alternative text and caption element
		do
			add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("img", "src=%"" + src + "%" alt=%"" + alt + "%"", "", ""), Void)
		end

	add_image (src, alt: STRING_32)
			-- Add a new image to the slider, with specified url and alternative text
		do
			add_image_with_caption (src, alt, "")
		end

	add_control (c: WSF_STATELESS_CONTROL; caption: detachable WSF_STATELESS_CONTROL)
			-- Add a new control to the slider
		local
			cl: STRING_32
			item: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create item.make ()
			item.add_class ("item")
			item.add_control (c)
			if attached caption as capt then
				item.add_control (capt)
			end
			cl := ""
			if slide_wrapper.controls.count = 0 then
				cl := "active"
				item.add_class (cl)
			end
			slide_wrapper.add_control (item)
			list.add_control (create {WSF_BASIC_CONTROL}.make_with_body_class ("li", "data-slide-to=%"" + list.controls.count.out + "%"", cl, ""));
		end

feature -- Properties

	list: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of slider links

	slide_wrapper: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			-- List of the single slides

end
