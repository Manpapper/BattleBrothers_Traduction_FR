this.flagellants_wounds_heal_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellants_wounds_heal";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]%flagellant% le flagellant est assis les jambes croisées devant le feu de camp. Il est tout seul, mis à part les papillons de nuit qui volent dangereusement près des flammes. Sentant votre présence, il vous appelle. Vous prenez place à côté de lui et il vous sourit.%SPEECH_ON%Je suis devenu un homme meilleur depuis que j\'ai rejoint cette compagnie.%SPEECH_OFF%Vous acquiescez, comme c\'est probablement le cas. Il continue.%SPEECH_ON%J\'ai beaucoup saigné pour les dieux, mais mes blessures... ne sont que des cicatrices maintenant. Je me sens plus fort que jamais.%SPEECH_OFF%Vous acquiescez à nouveau, mais vous lui demandez rapidement s\'il va arrêter de se faire du mal. Les yeux de l\'homme fixent les braises rouges. Il secoue la tête pour dire non.%SPEECH_ON%Je saignerai pour les dieux jusqu\'à ce qu\'ils n\'en disent plus rien.%SPEECH_OFF%S\'interrogeant à voix haute, vous demandez si les dieux lui ont parlé. Sans hésiter, l\'homme secoue à nouveau la tête pour dire non.%SPEECH_ON%Ils ne l\'ont pas fait et je saignerai donc jusqu\'à ce que leur silence soit brisé ou que je les rejoigne dans le silence éternel.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Donc le temps guérit toutes les blessures.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(4, 6);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.getFlags().add("wounds_scarred_over");
				this.List = [
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] de Points de Vie"
					}
				];
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
		local candidate_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("wounds_scarred_over"))
			{
				continue;
			}

			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidate_flagellant.push(bro);
			}
		}

		if (candidate_flagellant.len() == 0)
		{
			return;
		}

		this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		this.m.Score = candidate_flagellant.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
	}

});

