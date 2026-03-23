local repo_root = vim.fs.root(vim.fn.getcwd(), ".nvim.lua") or vim.fn.getcwd()
repo_root = vim.fs.normalize(repo_root)

local host_workspace = vim.fs.normalize(repo_root .. "/workspace")
local container_name = "ros-dev"
local container_workspace = "/root/ws"

local function in_workspace(bufnr)
	local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
	return path ~= "" and (path == host_workspace or vim.startswith(path, host_workspace .. "/"))
end

vim.lsp.enable("clangd", false)
vim.lsp.enable("cpptools", false)

vim.lsp.config("clangd", {
	cmd = {
		"docker",
		"exec",
		"-i",
		"-w",
		container_workspace,
		container_name,
		"clangd",
		"--enable-config",
		"--background-index",
		"--compile-commands-dir=" .. container_workspace,
		"--query-driver=/usr/bin/**",
		"--path-mappings=" .. host_workspace .. "=" .. container_workspace,
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_dir = function(bufnr, on_dir)
		if in_workspace(bufnr) then
			on_dir(host_workspace)
		end
	end,
})

vim.lsp.enable("clangd")
