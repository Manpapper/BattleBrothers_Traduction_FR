this.nightowl_catches_thief_event <- this.inherit("scripts/events/event", {
	m = {
		NightOwl = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.nightowl_catches_thief";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Waking from a strange dream, you step out of your tent to find most of the company asleep, aside from the night owl %nightowl%. He\'s at the edge of the camp with his back turned, but he seems to hear you approaching and speaks without looking.%SPEECH_ON%This is how it starts, sir. The rage. The fever. That turns good men, hoooo.%SPEECH_OFF%He wheels around to show off an actual owl he has caught. Its eyelids are half-closed, probably worn out from escaping and now simply humiliated at being caught without any carnivorous purpose. You ask %nightowl% how the hell he caught it. The sellsword lets the bird go and shrugs.%SPEECH_ON%With my hands. I also caught this.%SPEECH_OFF%He crouches and pulls up a heretofore unseen corpse.%SPEECH_ON%Slick little thief. I happened upon him, eh, discounting our wares so to speak. I was a little too tired to talk, so I let my blade here tell him the shop\'s closed. I then followed his footsteps out to where he came from and found his, eh, let\'s say accoutrements.%SPEECH_OFF%You nod. Right. Of course. You tell the man you\'re going back to sleep and you\'ll make judgments of his doings in the morning. He nods back.%SPEECH_ON%Right sir. I\'ll try and get some shuteye myself. Been a couple days. Or was it weeks?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NightOwl.getImagePath());
				_event.m.NightOwl.improveMood(1.0, "Caught a thief at night");

				if (_event.m.NightOwl.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.NightOwl.getMoodState()],
						text = _event.m.NightOwl.getName() + this.Const.MoodStateEvent[_event.m.NightOwl.getMoodState()]
					});
				}

				local trait = this.new("scripts/skills/effects_world/exhausted_effect");
				_event.m.NightOwl.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.NightOwl.getName() + " is exhausted"
				});
				local money = this.Math.rand(100, 300);
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
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
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.night_owl"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NightOwl = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nightowl",
			this.m.NightOwl.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.NightOwl = null;
		this.m.FoundItem = null;
	}

});

