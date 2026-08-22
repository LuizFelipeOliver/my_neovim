local mason_jdtls = vim.fn.stdpath('data') .. '/mason/share/vscode-spring-boot-tools/jdtls'

local extension_jars = vim.fn.glob(mason_jdtls .. '/*.jar', true, true)

local cmd = { 'jdtls' }

if #extension_jars > 0 then
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
