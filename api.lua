
function mtt.register(name, fn)
    table.insert(mtt.jobs, {
        name = name,
        fn = fn
    })
end