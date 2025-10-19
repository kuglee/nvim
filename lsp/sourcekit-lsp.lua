return {
  cmd = { vim.fn.trim(vim.fn.system "xcrun -f sourcekit-lsp") },
  filetypes = { "swift" },
  root_markers = { ".xcodeproj", ".xcworkspace", "Package.swift" },
}
