
br = peripheral.find("block_reader")

term.clear()
term.setCursorPos(1,1)

-- Helper functions --

function newLine()
    local x,y = term.getCursorPos()
	term.setCursorPos(1,y+1)
end

function parseClipboard(slot)
	local out = {}
	local num = 0
	local cbc = br.getBlockData().Items[1].components["create:clipboard_content"]
	for i,page in ipairs(cbc.pages) do
		for j,entry in ipairs(page) do
			local count = entry.item_amount
			local item = entry.icon.id
			if (count ~= 0) and (item ~= nil) then
				num = num + 1
				out[num] = {item=item,count=count}
			end
		end
	end
	return out
end

function printList(list)
	for i,entry in ipairs(list) do
		print(entry[item].." - "..entry[count])
		newLine()
	end
end