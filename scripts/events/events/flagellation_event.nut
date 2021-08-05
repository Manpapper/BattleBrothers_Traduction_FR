this.flagellation_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.flagellation";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%otherguy% s\'approche avec un air contrarié sur son visage. Son casque à la main, il s\'essuie le front.%SPEECH_ON%Monsieur, euh, vous devriez venir voir ça.%SPEECH_OFF%Vous vous renseignez sur ce que vous allez voir.%SPEECH_ON%Je n\'ai pas les mots pour le dire. Vous feriez mieux de venir et de voir de vos propres yeux.%SPEECH_OFF%Vous regardez votre travail - tracer la marche pour les jours à venir - mais, à en juger par le regard de votre frère d\'arme, cela peut attendre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Montre-moi ça.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]Vous vous levez et le laissez vous guider vers ce qui pose problème. Vous tombez sur une foule de mercenaires encerclant quelque chose ou quelqu\'un. Vous vous frayez un chemin à travers la foule, la compagnie se calme et vous arrivez dans la clairière pour trouver %flagellant_short% le flagellant inconscient sur le sol.\n\nSon dos est à vif et vous pensez même pouvoir voir une côte ou deux. Des épines se sont détachées de son fouet brutal, s\'incrustant dans sa chair, et sa peau pend par mèches, quand elle pend encore. C\'est une bonne chose qu\'il se soit évanoui. Non pas parce qu\'il souffrirait horriblement, mais parce que vous pensez qu\'il ne se serait peut-être pas arrêté autrement. Vous ordonnez aux hommes de le nettoyer, de panser ses blessures et de cacher ces outils de malheur.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, il ne s\'est pas tué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.Flagellant.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
				else
				{
					_event.m.Flagellant.addLightInjury();
					this.List = [
						{
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = _event.m.Flagellant.getName() + " souffre de blessures légères"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Flagellant = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 10;

			foreach( bro in brothers )
			{
				if (bro.getID() != this.m.Flagellant.getID())
				{
					this.m.OtherGuy = bro;
					break;
				}
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
		_vars.push([
			"flagellant_short",
			this.m.Flagellant.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.OtherGuy = null;
	}

});

