this.sellsword_vs_bees_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_bees";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{The desert is not home to much of anything beyond the sands. So it is rather particular when you come across a lone tree setting out by itself, and even more stranger that hanging from a branch is a fat beehive with a cloud of workers swarming around its bulbous shape. Even at some distance, you can see the golden ember of their honey glistening...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Someone go fetch it!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Good" : "Fail";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Looks like %wildmanfull% wants to go for it.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				this.Options.push({
					Text = "Let\'s go. Nothing good can come of this.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "%terrainImage%{%chosen% confidently walks up toward the tree and the bees seem shunted away by his very presence. The noise of their fluttering thickens with angry vibrations, but otherwise they take no further offense. He carefully scoops some of the honey into a jar and then eases back and steps away. He returns to the company.%SPEECH_ON%Easy peasy beehive squeezy, lads.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Buzz all you want, this honey is ours!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.75, "Enjoyed some honey in the desert");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Fail",
			Text = "%terrainImage%{%chosen% laces his fingers and cracks the knuckles with a long stretch.%SPEECH_ON%Like stealing candy from a baby.%SPEECH_OFF%He walks up to the tree and stands beneath the hive. He poses and points up at it, laughs, then turns his hands up and - much to the shock of everyone - just grabs the entire beehive. The bees instantly swarm the sellsword and he drops the hive and sprints away, a cloud of angry buzzing chasing him down a sand dune. He rolls and rolls, his screams issuing out whenever he flies out of the sand, and then he lands at the bottom and a wash of sand covers him and spares him from further bee stings. You wait a while before retrieving him, lest the bees know your hand in this attempted thievery.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s not do that again.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(2.0, "Was brutalized by bees");
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Dude.getName() + " suffers heavy wounds"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Wildman",
			Text = "%terrainImage%{You\'re sure %wildman% the Wildman has seen a hive or two in his time estranged to the forests. He grunts and points at the beehive and then at himself. You nod. He grunts again and goes up the sand dune to the tree while you watch from a safe distance. When he stands beneath the hive, he hoots again, cupping his hand over his mouth to make sure you hear him. He points at the beehive. You nod again and point aggressively at the hive. It\'s the only beehive for miles, what could possibly be so confusing about this? \n\n The Wildman turns toward the beehive. He cocks an arm back. That... that is not what you wanted to see. He sizes up the beehive, tongue out, eyes slimmed. You rush forward, yelling at him, but he\'s already honed in. He launches a fist and absolutely obliterates the bees. Honeycombs stickily flail around his wrist as though his hairy arm were an impromptu maypole. The Wildman casually walks back down the sand dune. As he nears, you see bees crawling all over his face and stinging away like the pissed off savages that they are, but he doesn\'t seem to even sense their presence. He holds out the crunchy remains of his honeyed demolition as though he held the heart of a ferocious beast.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good... job",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Wildman.getName() + " suffers light wounds"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50 || bro.getID() == _event.m.Wildman.getID())
					{
						bro.improveMood(0.75, "Enjoyed some honey in the desert");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"chosen",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Wildman = null;
	}

});

