
br = peripheral.find("block_reader")
st = peripheral.find("rs_bridge")
storage_side = "top"

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)
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
                out[num] = {name=item,count=count}
            end
        end
    end
    return out
end

function printList(list)
    for i,entry in ipairs(list) do
        print(i..": "..entry["name"].." - "..entry["count"])
        newLine()
    end
end

function exportItem(entry)
    st.exportItem(entry,storage_side)
end

function getStoredCount(entry)
	return st.getItem(entry)["amount"]
end

function exportAllItems(list)
    for i,entry in ipairs(list) do
		request_quantity = entry["count"]
		stored_quantity = getStoredCount(entry)
		if stored_quantity >= request_quantity then
			exportItem(entry)
			term.setTextColor(colors.green)
			print(i..": "..entry["name"].." - "..entry["count"])
		else
			term.setTextColor(colors.red)
			print(i..": "..entry["name"].." - "..entry["count"])
		end
    end
end

lst = parseClipboard(1)
printList(lst)
exportAllItems(lst)