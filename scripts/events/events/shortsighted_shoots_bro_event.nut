this.shortsighted_shoots_bro_event <- this.inherit("scripts/events/event", {
	m = {
		Shortsighted = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.shortsighted_shoots_bro";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img] Vous jetez un long regard sur les hommes, un regard qui passe de l\'un à l\'autre, puis revient, tout en secouant la tête. %shortsightedtarget% se tient la tête, une bosse assez importante s\'élevant à la racine des cheveux. Il regarde %shortsighted% puis vous. Les deux hommes haussent les épaules. Vous demandez à %shortsighted% ce qui s\'est passé. Il explique. %SPEECH_ON% J\'ai cru voir quelque chose qui n\'était pas là. %SPEECH_OFF%abasourdi, %shortsightedtarget% leve sa main jusqu\'à ses épaules.%SPEECH_ON%J\'ai dit, \"Hé, c\'est moi\" et tu m\'as quand même frappé.%SPEECH_OFF% Lève ses mains en guise de rédition, %shortsighted% se défend. %SPEECH_ON% \"Hé, c\'est moi\" ne sont pas des mots qui me permettent de t\'identifier ! N\'importe quel homme peut dire ces mots ! Je pense que n\'importe quel homme de mauvaise volonté dirait ces mots avant de les suivre avec une épée, je parie qu\'il le ferait!%SPEECH_OFF%Il semble que la mauvaise vue de %shortsighted%\ a conduit à une sorte d\'accident.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites examiner cette blessure, %shortsightedtargetshort%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shortsighted.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local injury = _event.m.OtherGuy.addInjury(this.Const.Injury.PiercingBody, 0.4);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.OtherGuy.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Shortsighted.worsenMood(1.0, "A frappé " + _event.m.OtherGuy.getName() + " par accident");
				_event.m.OtherGuy.worsenMood(1.0, "A été frappé par " + _event.m.Shortsighted.getName());

				if (_event.m.OtherGuy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy.getMoodState()],
						text = _event.m.OtherGuy.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_shortsighted = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_shortsighted.push(bro);
			}
		}

		if (candidates_shortsighted.len() == 0)
		{
			return;
		}

		this.m.Shortsighted = candidates_shortsighted[this.Math.rand(0, candidates_shortsighted.len() - 1)];
		this.m.Score = candidates_shortsighted.len() * 5;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Shortsighted.getID() && bro.getBackground().getID() != "background.slave")
			{
				this.m.OtherGuy = bro;
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
			"shortsighted",
			this.m.Shortsighted.getName()
		]);
		_vars.push([
			"shortsightedtarget",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"shortsightedtargetshort",
			this.m.OtherGuy.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Shortsighted = null;
		this.m.OtherGuy = null;
	}

});

