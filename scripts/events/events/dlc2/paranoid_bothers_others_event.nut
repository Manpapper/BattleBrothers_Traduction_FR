this.paranoid_bothers_others_event <- this.inherit("scripts/events/event", {
	m = {
		Paranoid = null
	},
	function create()
	{
		this.m.ID = "event.paranoid_bothers_others";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous entendez une agitation et vous allez trouver %paranoid% qui brandit une arme sur ses compagnons d'armes.%SPEECH_ON%Je sais qui vous êtes, et je sais qui vous n'êtes pas, et ce que vous n'êtes pas, ce sont des amis à moi !%SPEECH_OFF%%randombrother% vous regarde et hausse les épaules.%SPEECH_ON%Je n'ai jamais dit que tu étais mon ami.%SPEECH_OFF%Le mercenaire paranoïaque aboie quand même, exigeant que tout le monde se tienne à bonne distance ou il va les couper. Vous parvenez à le calmer, principalement en lui rappelant son salaire journalier et à quel point il aura du mal à s'en passer, mais c'est sans doute une solution à court terme. | Vous trouvez %paranoid%, le mercenaire de plus en plus paranoïaque, recroquevillé sur lui-même, les mains autour des genoux. Malgré cette posture infantile, ses yeux sont d'acier et il surveille tout avec attention. Lorsque vous lui demandez comment il va, il se contente de rire.%SPEECH_ON%Je ne sais pas, monsieur, je suis juste entouré d'une foule de connards motivés par l'argent qui pourrait me poignarder dans le dos quand ça les arrange.%SPEECH_OFF%D'une certaine manière, vous comprenez ce qu'il veut dire, mais vous espérez que cette attitude n'est pas contagieuse pour le reste de la compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Arrêtez d'être si paranoïaque.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Paranoid.getImagePath());
				_event.m.Paranoid.worsenMood(0.5, "Est paranoïaque à propos de ses camarades");

				if (_event.m.Paranoid.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Paranoid.getMoodState()],
						text = _event.m.Paranoid.getName() + this.Const.MoodStateEvent[_event.m.Paranoid.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.paranoid"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Paranoid = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"paranoid",
			this.m.Paranoid.getName()
		]);
	}

	function onClear()
	{
		this.m.Paranoid = null;
	}

});

