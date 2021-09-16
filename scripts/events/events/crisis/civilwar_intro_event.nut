this.civilwar_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_intro";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]You enter %townname% and find a group of laymen standing around a wooden platform. Thinking there\'s a hanging to be seen, you quickly push through the crowd. What you find instead is a queerly dressed man barking out news to the townsfolk.%SPEECH_ON%Harken harken harken, a determination has been made between the noble houses %noblehouse1% and %noblehouse2%! They have come to a conclusion all sides can agree upon: they hate one another!%SPEECH_OFF%Nervous whispers wrinkle the crowd. As the volume builds, the whispers crescendo into hushes. The minstrel continues.%SPEECH_ON%That is right, my fair fair-folk! War is upon us! Ah yes, that fickle beast which lies dormant in all men. A sad affair, a righteous affair, an honorable one!%SPEECH_OFF%An old man standing in front of you grumbles and spits. He leaves, shaking his head and murmuring to himself. The minstrel presses on, his excitement not matching the terrified faces before him.%SPEECH_ON%Let us not dawdle on ceremony. I\'ve been instructed to speak thusly: men, take up arms where you can, plough the fields while you can\'t. Women, raise yer sons right, lest they may raise a sword all wrong!%SPEECH_OFF%Finally, the minstrel takes a great big breath.%SPEECH_ON%And those among you who wish to earn a good crown or two, the noble houses are looking for the fine services of any man who can swing a sword. Those among you of lesser honor, you bridle-loosers, bride-stealers, leech-sellers, smellsmocks, ne\'er do wells, vice obsessed and run amuck, brigands, bandits, and thieving graduates, you sickly and poison moistened, the cursed and rabid, the cured and vapid, sellswords and poets selling words, this, my fine genteel men, is YOUR time. Go out there, fight for the nobles, and earn yourself a new life! A shame that a war shan\'t last forever, so best do it quick!%SPEECH_OFF%It looks as though the %companyname%\'s future just got brighter - on account of the loads of gold you\'re about to be earning.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "War is upon us.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("crisis_civilwar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					town = t;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Town = town;
			this.m.NobleHouse = this.m.Town.getOwner();
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_start");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"noblehouse1",
			this.m.NobleHouse.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local noblehouse2;

		do
		{
			noblehouse2 = nobles[this.Math.rand(0, nobles.len() - 1)];
		}
		while (noblehouse2 == null || noblehouse2.getID() == this.m.NobleHouse.getID());

		_vars.push([
			"noblehouse2",
			noblehouse2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.NobleHouse = null;
	}

});

