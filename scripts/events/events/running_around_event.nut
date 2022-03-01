this.running_around_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.running_around";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Marcher, courir, se battre, baiser, tout est bon pour le cœur d\'un homme. Le temps passé à parcourir le pays a amélioré la vitalité et la vigueur des hommes. Vous avez même surpris un des mercenaires les plus effrontés en train de s\'étirer dans l\'eau de l\'étang, admirant son propre reflet comme une jeune fille qui sourit. | Toute cette marche sur le terrain a augmenté l\'endurance des hommes. L\'un d\'eux court sur place en portant un doigt à son cou. Il remarque que son rythme cardiaque n\'augmente pas du tout. Un autre frère remarque que ce type ne sait même pas compter. L\'homme qui court fait une pause.%SPEECH_ON%Oh. C\'est vrai.%SPEECH_OFF%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça en vaut la peine.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = _event.m.Dude;
				this.Characters.push(bro.getImagePath());
				local stamina = this.Math.rand(1, 1);
				bro.getBaseProperties().Stamina += stamina;
				bro.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] de Fatigue Maximum"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

