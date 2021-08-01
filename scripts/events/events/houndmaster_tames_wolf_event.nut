this.houndmaster_tames_wolf_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.houndmaster_tames_wolf";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]While traversing the snowy wastelands of the realm\'s north, %houndmaster% the houndmaster has come to befriend a creature that\'s been trailing beside the company\'s march: a wolf. The houndmaster frequently remained in the rearguard, crouched low, hands at his side, locking eyes with the lone wolf for minutes on end. But today, using a bit of leftover meat, he plied the beast right into the middle of the camp. Now he squats at its side, dwarfed by its prominent, muscled withers, its pointed and attentive ears, and a lapping maw lined with mankilling canines.\n\n The rest of the men stand behind their weapons. One yells at the houndmaster to stop what he is doing. Another says the wolf can smell fear. Yet another throws a rock at it. The wolf winces, but doesn\'t react. Laughing, the houndmaster makes a \'tssst!\' noise and points. The wolf launches forward, picking up the stone and bringing it back to the man. He rubs the beast\'s mane.%SPEECH_ON%See, easily trained, just any dog. Only bigger, faster, and stronger. Smarter, too.%SPEECH_OFF%Its eyes meet yours. The wolf lays low, almost like a man bowing. %houndmaster% laughs again.%SPEECH_ON%See? It already knows who is alpha of this pack.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A noble beast.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wolf_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Houndmaster.improveMood(2.0, "Managed to tame a wolf");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

