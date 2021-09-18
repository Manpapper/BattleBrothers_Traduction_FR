this.trader_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.trader_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_95.png[/img]Les cadavres grouillent de mouches et %ch1% se tient au milieu de l\'essaim comme s\'il avait construit le totem mortel qui a provoqué leur présence. Il se tourne vers vous. %SPEECH_ON%Ce sont les peaux vertes qui ont fait ça. Aucun homme ne peut couper une tête en deux comme ça, et aucun homme sain d\'esprit ne les empilerait de cette manière. Et il y a du poison de gobelin sur les pointes de flèches. %SPEECH_OFF% %ch2% hoche la tête.%SPEECH_ON% Hier on a trouvé ce marchand pendu par des brigands, maintenant ça. Les routes deviennent trop dangereuses pour un chariot transportant du vin. Maintenant, je ne dis pas que mon épée ne vaut pas son poids en sel, mais avec seulement deux d\'entre nous en service, nous jetons les dés d\'heure en heure. Monsieur, vous devriez envisager d\'engager plus de gardes.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, ça va aller.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Je vais engager plus de gardes et même plus !",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_95.png[/img]Vous secouez la tête.%SPEECH_ON%Non. Ce que nous allons faire, c\'est nous défendre et même plus. J\'ai l\'intention d\'embaucher des mercenaires pour créer une compagnie, et si vous voulez gagner un salaire régulier, vous deux pouvez être les premiers.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "En avant, maintenant, nous avons des marchandises à vendre !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_95.png[/img]Tu secoues la tête.%SPEECH_ON%On fait à peine des profits comme ça. Je n\'ai pas les moyens d\'engager plus de gardes. A moins que nous ne trouvions une nouvelle route commerciale rentable, bien sûr. Et c\'est ce que j\'ai l\'intention de faire!%SPEECH_OFF%.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "En avant, maintenant, nous avons des marchandises à vendre !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Trading Caravan";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"ch1",
			brothers[0].getName()
		]);
		_vars.push([
			"ch2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});

