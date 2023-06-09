local text_source = io.open("alice_oz.txt", "r")
local key_size = math.tointeger(arg[1]) or 3
local word_length = math.tointeger(arg[2]) or 20

local state_transitions = {}
local states = {}


for line in text_source:lines() do
	local current_word = nil
	local key = {}
	for word in string.gmatch(line, "%g+") do

		table.insert(key, word)

		if #key == key_size + 1 then
			current_state = table.concat(key, " ", 1, #key - 1)
			table.insert(states, current_state)

			if state_transitions[current_state] == nil then
				state_transitions[current_state] = {}
			end
			table.insert(state_transitions[current_state], key[#key])

			for i, _ in ipairs(key) do
				if i == #key then
					key[i] = nil
				end
				key[i] = key[i + 1]
			end
		end
	end
end

local current_state = states[math.random(1, #states)]
local response_string = { current_state }
for i = 1, word_length - key_size do

	count = state_transitions[current_state]
	if count == nil then break end
	next_state = state_transitions[current_state][math.random(1, #count)]
	table.insert(response_string, next_state)

	new_state = {}
	for word in string.gmatch(current_state, "%g+") do
		table.insert(new_state, word)
	end
	table.insert(new_state, next_state)

	new_state_final = {}
	for j, _ in ipairs(new_state) do
		if j == key_size + 1 then break end
		new_state_final[j] = new_state[j + 1]
	end

	current_state = table.concat(new_state_final, " ")
end

print(table.concat(response_string, " "))
