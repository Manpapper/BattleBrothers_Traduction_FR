this.oathtaker_happy_with_company_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_happy_with_company";
		this.m.Title = "During camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% the Oathtaker joins you by the campfire. He nods.%SPEECH_ON%Respectfully, captain, I can say that it is a big ask to require a man to be of genuine goodness. When I first knew ya, I didn\'t think you had the chops for such an undertaking. I thought this world\'s creeping darkness would wither you away, grind you down like sand to a stone. But here you are. Stalwart. Keeping to the Oaths, one after the other. Good on ya. I think Young Anselm would be proud.%SPEECH_OFF%You thank the Oathtaker for the kind words.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Glad someone appreciates it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				_event.m.Oathtaker.getBaseProperties().Bravery += 2;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
				});
				_event.m.Oathtaker.improveMood(1.0, "Is happy about the company\'s moral compass");

				if (_event.m.Oathtaker.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoralReputation() < 80.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin" && bro.getLevel() >= 5)
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Score = 5 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

