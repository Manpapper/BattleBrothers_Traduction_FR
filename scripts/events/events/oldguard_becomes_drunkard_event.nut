this.oldguard_becomes_drunkard_event <- this.inherit("scripts/events/event", {
	m = {
		Oldguard = null,
		Casualty = null,
		OtherCasualty = null
	},
	function create()
	{
		this.m.ID = "event.oldguard_becomes_drunkard";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]You find %oldguard% nursing a rather large tankard next to a fire. In fact, it\'s not a tankard at all, but a wooden bucket filled with ale. A few more modest mugs are littered about his feet. He tips back, gulping from the bucket\'s lip. When he sees you, he tries to dress up, sloughing the foam off his face and attempting a smile that quickly sloops into a drunken frown.%SPEECH_ON%Hey there, captain. Didn\'t mean for you to see me like this.%SPEECH_OFF%You set yourself down by the man and ask how he is doing.%SPEECH_ON%Being drunk.%SPEECH_OFF%Nodding, you reach for the bucket and the man gives it up, though his hands are shaped as if to still be holding it. You set the bucket down and ask again how he is doing. He finally drops his hands into his lap.%SPEECH_ON%Like shit. That\'s how I\'m feeling. First, %casualty% went down. Then %othercasualty%. I know there\'s been at least five or six others. Just dead men. Come and gone. I got memories of them talking, and memories of them screaming, and I can\'t have one without the other. But I\'m alright now cause right now I can\'t even think straight. If I can\'t unlearn a memory, I\'ll just go ahead and drown it. The ale does me well, heh.%SPEECH_OFF%With a sigh, you hand the bucket back to the man. Eyes lost in the fire, his mind lost in the past, he says nothing else.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To absent friends...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oldguard.getImagePath());
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Oldguard.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Oldguard.getName() + " has become a drunkard"
				});
				_event.m.Oldguard.worsenMood(1.0, "Has lost too many friends");

				if (_event.m.Oldguard.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oldguard.getMoodState()],
						text = _event.m.Oldguard.getName() + this.Const.MoodStateEvent[_event.m.Oldguard.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 7)
		{
			return;
		}

		local numFallen = 0;

		foreach( f in fallen )
		{
			if (!f.Expendable)
			{
				numFallen = ++numFallen;
			}
		}

		if (numFallen < 7)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getLevel() >= 8 && !bro.getSkills().hasSkill("trait.drunkard") && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[0].Time && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[1].Time && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oldguard = candidates[this.Math.rand(0, candidates.len() - 1)];

		for( local i = 0; i < fallen.len(); i = ++i )
		{
			if (fallen[i].Expendable)
			{
			}
			else if (this.m.OtherCasualty == null)
			{
				this.m.OtherCasualty = fallen[i].Name;
			}
			else if (this.m.Casualty == null)
			{
				this.m.Casualty = fallen[i].Name;
			}
			else
			{
				break;
			}
		}

		this.m.Score = numFallen - 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Oldguard.getName()
		]);
		_vars.push([
			"casualty",
			this.m.Casualty
		]);
		_vars.push([
			"othercasualty",
			this.m.OtherCasualty
		]);
	}

	function onClear()
	{
		this.m.Oldguard = null;
		this.m.Casualty = null;
		this.m.OtherCasualty = null;
	}

});

