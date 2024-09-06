require('askGemini').setup({
    user_questions = {
        {
            cmd = 'Grammar',
            prompt = 'Check grammar and spelling'
        },
        {
            cmd = 'ExplainCode',
            prompt = 'What this code does?'
        }
    }
})
