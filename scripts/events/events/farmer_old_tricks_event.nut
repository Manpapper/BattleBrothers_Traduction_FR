this.farmer_old_tricks_event <- this.inherit("scripts/events/event", {
	m = {
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_old_tricks";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Vous trouvez %farmhand% assis à côté du chariot de la compagnie. Il est en train de faire rouler de la paille entre ses dents, la broyant ici et là et recrachant des flocons. Vous lui demandez à quoi il pense. Le fermier hausse les épaules.%SPEECH_ON%Ce que mon père m\'a dit sur la mise en balle du foin. Il avait cette méthode qui consistait à tourner le poignet en l\'attrapant et encore une fois en la relachant. Je n\'ai jamais réussi à faire la deuxième partie correctement.%SPEECH_OFF%L\'homme sort la paille et la fait claquer. Vous demandez.%SPEECH_ON%Mais tu as pu faire la première partie correctement ? Où est-ce que tu plantes le foin et le tire ?%SPEECH_OFF%Il acquiesce. Vous dites à l\'homme qu\'il n\'a besoin que de la première partie de cette technique pour étriper correctement un homme. Vous regardez son visage briller avec la réalisation.%SPEECH_ON%Oui... oui, c\'est ça ! Pourquoi n\'y ai-je pas pensé avant ? Vous êtes un génie, monsieur ! Je vais l\'essayer à notre prochaine sortie ! Ce sera comme une balle de foin !%SPEECH_OFF%Avec beaucoup plus de cris et de saignements, mais bien sûr.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mais essaie de ne pas de les jeter par-dessus ton épaule par contre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Farmer.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				_event.m.Farmer.getBaseProperties().MeleeSkill += meleeSkill;
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Farmer.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] de Maîtrise de Mêlée"
				});
				_event.m.Farmer.improveMood(1.0, "A réalisé qu\'il avait des connaissances en matière de combat");

				if (_event.m.Farmer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
						text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.farmhand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Farmer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
	}

});

