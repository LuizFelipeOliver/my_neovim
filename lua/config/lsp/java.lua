local mason_jdtls = vim.fn.stdpath('data') .. '/mason/packages/vscode-spring-boot-tools/jdtls'

local extension_jars = {
    mason_jdtls .. '/jdt-ls-extension.jar',
    mason_jdtls .. '/jdt-ls-commons.jar',
    mason_jdtls .. '/commons-lsp-extensions.jar',
}

local cmd = { 'jdtls' }

if vim.fn.isdirectory(mason_jdtls) == 1 then
    table.insert(cmd, '--jvm-arg=-Dorg.eclipse.jdt.ls.extension.paths=' .. table.concat(extension_jars, ','))
end

vim.lsp.config('jdtls', {
    cmd = cmd,
    filetypes = { 'java' },
    root_markers = {
        'pom.xml',
        'build.gradle',
        'build.gradle.kts',
        'settings.gradle',
        'settings.gradle.kts',
        '.git',
    },
    settings = {
        java = {
            configuration = {
                updateBuildConfiguration = 'automatic',
                maven = { downloadSources = true },
                runtimes = {},
            },
            completion = {
                guessMethodArguments = true,
                importOrder = {
                    'java',
                    'javax',
                    'jakarta',
                    'com',
                    'org',
                    'all other imports',
                },
            },
            eclipse = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            signatureHelp = { enabled = true },
        },
    },
})
