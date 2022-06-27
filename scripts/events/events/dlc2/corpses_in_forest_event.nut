this.corpses_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		BeastSlayer = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.corpses_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_132.png[/img]{En marchant dans la forêt, vous tombez sur un tas de cadavres brûlés enlacés dans une dernière étreinte ardente. C\'est une masse grouillante de membres calcinés avec, parfois, un visage qui fixant le ciel. La légère odeur de cochon brûlé est toujours présente, mais sans cochons. %randombrother% acquiesce à la vue.%SPEECH_ON%C\'est un gros tas immonde.%SPEECH_OFF%Vous acquiescez. En effet, c\'est le cas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être qu\'il y a quelque chose d\'utile là-dedans.",
					function getResult( _event )
					{
						if (_event.m.BeastSlayer != null && this.Math.rand(1, 100) <= 75)
						{
							return "D";
						}
						else if (_event.m.Killer != null && this.Math.rand(1, 100) <= 75)
						{
							return "E";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "B" : "C";
						}
					}

				},
				{
					Text = "Mieux vaut ne pas s\'attarder ici.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_132.png[/img]{Les mercenaires commencent à fouiller les corps. La plupart des cadavres se présentent en paquets de trois ou quatre, qu\'il faut casser comme des œufs. Il faut un coup de botte ou une cale en acier pour les séparer. Des morceaux de chair carbonisée s\'envolent pendant que les hommes travaillent. Les enfants brûlés sont décollés comme des plastrons, leurs poitrines se sont affaissées et leurs bras sont tendus comme des rayons. On ne découvre pas grand-chose sous les corps. Quelques morceaux d\'or, tout au plus. %randombrother% trouve une sorte de masque macabre. Vous n\'êtes pas tout à fait sûr de ce que c\'est, mais vous vous êtes dit que ça ne ferait pas de mal de l\'emporter. Peut-être qu\'un commerçant trouvera ça intéressant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons sur la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/misc/petrified_scream_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%randombrother% s\'accroupit à côté de la boule de cadavres calcinés et secoue la tête.%SPEECH_ON%Je ne pense pas qu\'il y ait quoi que ce soit là-dedans, monsieur.%SPEECH_OFF%Avant que vous puissiez répondre, une main noire jaillit et attrape l\'homme par la cheville. Les corps se soulèvent et se déplacent, une seule victime s\'extirpe de ce charnier, son dos ressemble à une cape de cadavres carbonisés. Sa bouche est grande ouverte, les lèvres sont brûlées et les joues creuses, les yeux sont écrasés dans leurs orbites. Sa main a la poigne d\'une griffe de gargouille en pierre et lorsque le mercenaire rampe en arrière, il ne fait qu\'entraîner l\'homme brûlé avec lui. L\'ensemble du tas se met à bouger et à dégringoler, certains corps roulant sur le tas avec leurs membres bien tendus comme des tables basses, d\'autres se retournant pour fixer le ciel et un autre s\'élançant vers l\'avant et s\'écrasant la tête sur le sol, collant une marque noire poudreuse.\n\n Gémissant, le survivant réclame de l\'eau. Vous dégainez votre épée et la plantez dans son cou, mettant fin à sa douleur sur le champ. %randombrother% casse les doigts pour libérer sa botte de la main macabre. Quelques-uns des mercenaires sont ébranlés par l\'événement.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons sur la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(0.75, "Shaken by a gruesome scene");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_132.png[/img]{Le %beastslayer% lève la main.%SPEECH_ON%Ils n\'ont pas été assassinés, ils ont été purgés.%SPEECH_OFF%Il s\'accroupit à côté du tas et soulève un bras carbonisé qu\'il arrache au niveau du coude. Il retourne le bras et le serre. Du pus vert suinte de l\'endroit où se trouveraient les veines, dégoulinant constamment vers le sol. Le tueur de bêtes prend une fiole et récupère ce qu\'il peut.%SPEECH_ON%Ces gens ont été infectés par le poison d\'un Webknecht. Elle dissout généralement les organes et tue, mais parfois, elle a d\'autres effets. Provoque une poussée de poils épais sur les bras, d\'ongles longs, les omoplates commencent à être douloureuses et ressortent du dos. Horrible. Et les empoisonnés, eh bien, ils deviennent fous.%SPEECH_OFF%Vous demandez si tous ces gens ont été empoisonnés. Le tueur de bêtes secoue la tête.%SPEECH_ON%Celui-là, je le connaissais par cœur, les autres, je ne sais pas. Quand une maladie s\'empare d\'un village, elle s\'empare du village tout entier, et bientôt le chaos et la confusion deviennent la vraie contagion et la maladie elle-même n\'est plus qu\'une étincelle oubliée qui dérive dans le feu de joie qu\'elle a elle-même allumé.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons sur la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
				local item = this.new("scripts/items/accessory/spider_poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%killer% le meurtrier en cavale sourit, renifle, acquiesce, crache et acquiesce encore. Il montre du doigt la pile de corps.%SPEECH_ON%C\'est une cruauté si barbare que je ne pense pas que son auteur ait survécu à son acte.%SPEECH_OFF%Vous demandez ce qu\'il veut dire, mais l\'homme lève un doigt et marche dans la forêt, regardant derrière chaque arbre jusqu\'à ce qu\'il s\'arrête.%SPEECH_ON%C\'est ce que je pensais.%SPEECH_OFF%Vous vous retournez pour voir un la dépouille d\'un homme pendu. Le bout de ses doigts est noir, il y a de la cendre sur son visage et une corde autour de son cou. Une note dans sa main porte des excuses, bien qu\'elle ne décrive pas la nature de son crime si crime il y a eu. Sous ses pieds se trouvent son armure et ses armes. C\'était peut-être un noble. Quoi qu\'il en soit, vous avez découpé le corps et tout pillé.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons sur la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/morning_star");
				item.setCondition(this.Math.rand(5, 30) * 1.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setCondition(this.Math.rand(25, 60) * 1.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			local d = s.getTile().getDistanceTo(myTile);

			if (d <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_beastslayer = [];
		local candidates_killer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.BeastSlayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.BeastSlayer = null;
		this.m.Killer = null;
	}

});

