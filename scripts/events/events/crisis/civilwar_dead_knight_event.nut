this.civilwar_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_dead_knight";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]You happen across a throng of kids scrambling around something in the grass like flies on a shitpile. %randombrother% starts booting them away.%SPEECH_ON%Scamper you larks. Scamper! Oh, damn. Sir, come take a look!%SPEECH_OFF%A fat-faced chubster of a kid yells at you.%SPEECH_ON%I found it first! It\'s mine!%SPEECH_OFF%You effortlessly palm him out of the way and get a look. There\'s a dead knight in the grass and he\'s no doubt been there for a while. A soft tik-tik-tik noise emits from his armor as ants crawl all over it. A little girl holds her nose with a pinch. Somewhat nasally and high-pitched, she tries her hand at some astute diplomacy.%SPEECH_ON%Let \'em have it, Robbie! These men are dangerous! Aren\'t ya? Aren\'t ya some dangerous men?%SPEECH_OFF%%randombrother% unsheathes his weapon and dramatically flashes it around.%SPEECH_ON%The tiny wench is right! Y\'all best git before we put ya in the dirt just like we did this here knight! That\'s right, we are his murderers and we\'ve come back to see our handiwork!%SPEECH_OFF%Screaming and crying, the kids are scattered like birds from a bush. Robbie remains behind, leering over a bush at his lost treasures. You tell the mercenary he didn\'t need to scare them so badly. He shrugs and starts collecting the knight\'s gear.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Still useful.",
					function getResult( _event )
					{
						if (_event.m.Thief != null)
						{
							return "Thief";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/helmets/faction_helm");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_97.png[/img]%thief% eyes Robbie who you notice is beginning to sweat. The sellsword points a finger.%SPEECH_ON%You\'re not just a fat piece of shit, kid. What are you hiding under your shirt? You won\'t fool a thief, c\'mon, show it!%SPEECH_OFF%Sighing, Robbie lifts his shirt and a bunch of crowns go clattering into the grass. The man nods.%SPEECH_ON%That\'s what I thought. Now git.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Good eye.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 10 && t.getTile().getDistanceTo(playerTile) >= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief" || bro.getSkills().hasSkill("trait.eagle_eyes"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Thief = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
	}

});

