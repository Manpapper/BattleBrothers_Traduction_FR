this.hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hunt_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{As you help %otherguy% get his boot out of the mud, %hunter% comes out of the bushes with what must be nearly a dozen rabbits strung together. He sets them down and starts to untie them. The little bunnies - eyes wide, horrified in the end - all look quite tasty. The hunter grabs one by its neck and twists its body in a circle before pushing all its guts out in one swift motion. He repeats this process until every rabbit has been slaughtered. As he wipes his hand on %otherguy%\'s cloak, the hunter points to the mound of emptied bunnies at his feet.%SPEECH_ON%That there is the eating pile.%SPEECH_OFF%He then points to the lump of rabbit guts.%SPEECH_ON%That there is not the eating pile. Got it? Good.%SPEECH_OFF%  | %hunter% ran on ahead of the party a few hours ago and just now you catch back up to him. He\'s standing with his foot on a dead deer, its chest punctured by a single arrow. As you approach, he grins and steps off. He says if some of the brothers can help string it up he\'ll skin it and prep it. | Forest birds chitter and chatter above the company\'s march. The sun winks between the canopy branches, a soft glint that peppers the ground with dots of light. You spot a squirrel resting in one of the sun beams, enjoying the warmth as it gnaws on an acorn. It stops, sensing you watching it, and then it suddenly jerks and a fleck of its blood meets your cheek. You wipe it away, turning back to see that the squirrel has been impaled by an arrow, every shrieking death throe quieter than the last as the volume of its life slowly turns down. %hunter% suddenly breaks through the bushes with a bow in hand and a grin on his face. The hunter retrieves his kill and throws it in with a litter of others, a long hunter\'s line around which are tied all manner of critters foe and friend alike.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good eats.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You gain Venison"
					}
				];
				_event.m.Hunter.improveMood(0.5, "Has hunted successfully");

				if (_event.m.Hunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hunter.getMoodState()],
						text = _event.m.Hunter.getName() + this.Const.MoodStateEvent[_event.m.Hunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Hunter.getID())
			{
				this.m.OtherGuy = bro;
				this.m.Score = candidates.len() * 10;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.OtherGuy = null;
	}

});

