this.monk_crafts_holy_water_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.monk_crafts_holy_water";
		this.m.Title = "During camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%monk% the modest monk enters your tent with a vial in hand. The flask is topped with a bark stopper and a wreath of greenery with berries hanging beneath the leaves. Inside the vial is a goldish liquid sloshing about. Whatever it is, it catches any glimpse of light and seems to capture it and swirl it around. He holds it out.%SPEECH_ON%Blessed water, sir, to fight the dead that walk again.%SPEECH_OFF%You ask if it\'s a gift from the old gods. He nods. You ask if it\'s really a gift from the old gods, though. He purses his lips.%SPEECH_ON%No, not exactly. The monasteries know how to make it, but it is an ancient recipe protected under penalty of death.%SPEECH_OFF%Of course. You thank the man for taking such a risk to contribute and tell him to put it in the inventory.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Even holy men have tricks of the trade.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

