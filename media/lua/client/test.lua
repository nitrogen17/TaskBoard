require('main')

function test()
    print("main0: ", mainWindow)
    main()
    print("main1: ", mainWindow)
    print("main1A: ", rightListBox)
    destroyKanbanBoard()
    print("main2: ",mainWindow)
    print("main2A: ", rightListBox)
end
