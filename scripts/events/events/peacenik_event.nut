this.peacenik_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.peacenik";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]While on the path, you come across a man staring at a hole in the ground. Naturally, you go over and ask what he\'s doing. He states that there\'s an orc in the pit. You look down. There is. Taking out your sword, you ask if you should take care of it for him. He reels back.%SPEECH_ON%What? No! I want that alive. I think we can try and understand it.%SPEECH_OFF%Understand it? What is this man on about? He pleads.%SPEECH_ON%Let us merely try! Everyone kills an orc on sight, but they\'re not mere animals. They show intelligence, and if they have intelligence it means that they can learn, and if they can learn then perhaps they can learn to coexist with us.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dogs are smart, too, but what do we do with the bad ones?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Right. Good luck with that.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]%houndmaster% the houndmaster nods and explains that an animal, no matter how intelligent or well trained, is still an animal. The peacenik thinks for a time.%SPEECH_ON%I-it\'s not a mere dog, though!%SPEECH_OFF%Your houndmaster takes the man by the shoulder.%SPEECH_ON%But you\'ve cornered it like one, haven\'t you? What do you think a man would do in this situation, all his intellect and wisdom with him, his back to a wall and enemies afoot? This is not the place nor time for making \'peace,\' friend, whether it be with man or beast.%SPEECH_OFF%The stranger slowly begins to nod. He sees the sense of the argument and, thankfully, lets you destroy the orc without any incident. With the greenskin put away, the man gives you a satchel of crowns.%SPEECH_ON%I wanted to try and parlay with it using these. That ain\'t happening now, clearly, and I\'d probably be dead if you hadn\'t shown up. Consider this my thanks, sellsword.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Much appreciated.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				this.World.Assets.addMoney(50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Crowns"
				});
				_event.m.Houndmaster.getBaseProperties().Bravery += 1;
				_event.m.Houndmaster.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Houndmaster.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Houndmaster.improveMood(1.0, "Gave a lecture on the nature of animals");
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
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

