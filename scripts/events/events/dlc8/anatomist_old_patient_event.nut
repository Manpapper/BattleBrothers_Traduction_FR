this.anatomist_old_patient_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_old_patient";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_77.png[/img]{%townname%\'s denizens have mostly looked upon you and the anatomists as though you were wayward devils. But out of the blue, a man comes down off his porch and strides across the road toward %anatomist% the anatomist, carrying with him an upright posture, swinging gait, and a fat grin. He grabs the anatomist by the hand and starts vigorously shaking it.%SPEECH_ON%Shitfire, I\'d figured you\'d be back one of these days! You don\'t recognize me? You done come by this way years ago, many years ago, we both looked a fair bit younger then. I had that fat sack on m\'back that you cut out, and my whole life\'s been much better since! Hells, gimme one second, don\'t you move a muscle I\'ll be right back!%SPEECH_OFF%The man quickly returns to his home. You look at %anatomist% who remarks that he remembers the man: he had a giant tumor growing on his spine, and the anatomist in his younger days had successfully cut it out using tongs, shearing blades, and a good number of rags. He laments that he did not keep the fleshy mass for study, but that he was a different sort of physician in those days. The man returns with a weapon which he holds out.%SPEECH_ON%Once I was of good health, I took to the fightin\' fields. Was pretty good at it, too, but you know, lives change, and keep on changing. I\'d seen you with this sellsword here so I suppose it had done changed for you as well. Please, take it.%SPEECH_OFF%The second the anatomist hesitates, you take the weapon yourself, lest the charitable opportunity be shortlived. You thank the man. He shakes %anatomist%\'s hands again, then bids goodbye. The anatomist stares at him as he departs.%SPEECH_ON%We could experiment on him, now that I fully recollect my knowledge of him. That mass from his back is likely to return, I could perhaps...just...open him up and take a look...%SPEECH_OFF%You stop the anatomist from fancying any dissecting of the local laity and get back on the road.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ll find plenty of black masses to research elsewhere.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/arming_sword",
					"weapons/winged_mace",
					"weapons/warhammer",
					"weapons/fighting_spear",
					"weapons/fighting_axe",
					"weapons/military_cleaver"
				];
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "You gain " + weapon.getName()
				});

				if (this.Math.rand(1, 100) <= 75)
				{
					_event.m.Anatomist.improveMood(0.75, "Saw living proof that his past work was successful");
				}
				else
				{
					_event.m.Anatomist.improveMood(0.5, "An old patient thanked him for his medical help");
				}

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
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

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Town = null;
	}

});

