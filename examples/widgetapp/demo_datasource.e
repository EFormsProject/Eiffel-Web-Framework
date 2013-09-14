note
	description: "Summary description for {DEMO_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEMO_DATASOURCE

inherit

	WSF_PAGABLE_DATASOURCE [DEMO_DATA]

create
	make_demo

feature

	make_demo
		do
			page := 1
			page_size := 10
		end

	data: ITERABLE [DEMO_DATA]
		local
			list: LINKED_LIST [DEMO_DATA]
		do
			create list.make
			across
				((page - 1) * page_size + 1) |..| (page * page_size).min (131) as c
			loop
				list.extend (create {DEMO_DATA}.make (c.item, "Name" + c.item.out, "desc " + c.item.out))
			end
			Result := list
			row_count := 132
		end

end
