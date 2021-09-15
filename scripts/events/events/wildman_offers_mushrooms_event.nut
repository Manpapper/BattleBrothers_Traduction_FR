this.wildman_offers_mushrooms_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.wildman_offers_mushrooms";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous vous reposez à la base d\'un arbre énorme. Le soleil a réussi à se frayer un chemin à travers la canopée de la forêt et à vous aveugler. En vous levant pour bouger, vous tombez sur %wildman% le sauvage. Il vous offre une poignée d\'objets divers : champignons, pétales de fleurs, baies. Avec un grognement, il les dirige vers votre visage.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr, %wildman%, je vais en prendre un peu.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Humm, non merci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Étonnamment, les morceaux de nourriture forestière sont en fait assez bons. Doux, mais pas trop, et avec un soupçon de chêne. Vous remerciez le sauvageon pour son cadeau. Il s\'élève dans les cieux, les cieux de toutes choses, secouant ce qui est maintenant des branches que vous aviez pris pour des bras humains. Les chats pleuvent de sa bouche quand il parle. Sa langue est un language de lettres marbrées, flottant devant ses lèvres dans de grands soupirs pour des phrases. Heureux de ses grâces, vous lui faites un signe de la main, mais vous constatez que vos doigts sont aussi des mains, ce que vous n\'aviez pas remarqué auparavant. Un choc pour vos croyances, vos souvenirs d\'enfance inondés de pieds fugaces berçant votre berceau, votre domaine, votre château. Tout est mensonge. Tout cela ! Les ténèbres arrivent. Les ténèbres sourient. Vous vous réveillez sur le sol, %otherguy% vous tamponne doucement le front avec un chiffon d\'eau.%SPEECH_ON% Il est revenu à lui, tu vas bien ? %SPEECH_OFF% Vous vous ne vous souvenez pas vraiment de ce qui s\'est passé, mais votre esprit vous dit désespérément de ne pas demander. Vous faites simplement un signe de tête en guise de réponse et vous remettez les hommes en marche.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'ai appris quelque chose aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_wildman.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
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
		this.m.Wildman = null;
		this.m.OtherGuy = null;
	}

});

