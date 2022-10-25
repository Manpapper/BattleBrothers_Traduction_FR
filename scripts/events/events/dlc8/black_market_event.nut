this.black_market_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Price = 0,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.black_market";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Les charrettes de fruits de %townname% sont chargées de toutes sortes de délicieuses douceurs, bien qu\'excessivement chères. Vous regardez de travers l\'un de leurs propriétaires, espérant détourner son attention pour lui voler quelques fruits.Juste au moment où vous êtes sur le point de faire le coup, %anatomist% l\'anatomiste arrive en courant, attirant toute l\'attention de la foule autour de lui. Vous cachez votre petit larcin et lui demandez ce qu\'il veut. Il sourit.%SPEECH_ON%Nous avons trouvé le marché noir de %townname%.%SPEECH_OFF%Vous vous rendez sur place et trouvez un homme maigrelet, appuyé sur une chaise. Sur le bureau en face de lui se trouve un assortiment de \"marchandises\", si on peut les appeler ainsi. Pour vous, il ressemble à un tas de merde indéfinissable, mais pour l\'anatomiste, il pourrait aussi bien être un cadeau des dieux anciens. En bâillant, l\'homme rachitique dit \"Faites votre choix\". %anatomist% se penche de plus près pour évaluer les marchandises et en trouve trois qui semblent être douteux. Il prévient que la compagnie ne devrait peut-être en acheter qu\'un seul.%SPEECH_ON%Si les gardes nous trouvent avec trop de marchandises, ils peuvent nous confondre avec des colporteurs au lieu de simples acheteurs, et le trafic de ces marchandises est un véritable délit.%SPEECH_OFF%Vous jettez un coup d\'œil aux marchandises.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenons ce truc qui ressemble à un cerveau pour 100 couronnes.",
					function getResult( _event )
					{
						_event.m.Price = 100;
						return this.Math.rand(1, 100) <= 85 ? "Brain" : "Bunk";
					}

				},
				{
					Text = "Je prendrai le gros coeur pour... 550 couronnes, c\'est ça?",
					function getResult( _event )
					{
						_event.m.Price = 550;
						return this.Math.rand(1, 100) <= 95 ? "Heart" : "Bunk";
					}

				},
				{
					Text = "Je paierai 200 couronnes pour cette... sorte de glande?",
					function getResult( _event )
					{
						_event.m.Price = 200;
						return this.Math.rand(1, 100) <= 90 ? "Gland" : "Bunk";
					}

				},
				{
					Text = "Nous ne pouvons pas nous permettre de telles excentricités.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Brain",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Vous achetez ce qui ressemble à un bloc de nouilles condensées, dont les filaments spongieux sont gris et dont la texture moelleuse est tachetée de points noirs. De façon assez dégoûtante, %anatomist% pose toute sa paume sur la substance et appuie dessus. Lorsqu\'il retire sa main, l\'empreinte persiste, la chair se reforme d\'elle-même. Il sourit.%SPEECH_ON%Je crois que nous pouvons étudier cette chose et en tirer profit.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est dégoutant mais d\'accord.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/ghoul_brain_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Heart",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Une brouette est nécessaire pour transporter l\'énorme organe. %anatomist% affirme qu\'il s\'agit du cœur d\'un Unhold et qu\'il sera très utile comme spécimen d\'étude. La brouette est abaissée et vous y jetez tous les deux un coup d\'œil. Vous, profane inculte et non éduqué, regardant quelque chose de grossier et d\'inesthétique, tandis que l\'anatomiste, profane inculte et éduqué, regardant quelque chose de grossier et de fascinant. Ce qui vous met mal à l\'aise, c\'est que quelque chose d\'aussi massif puisse être au cœur d\'une bête. Le cœur de l\'homme est petit, mais il déborde de chaleur et de volonté pour tout soumettre à son autorité. Pourtant, ce cœur...\n\nDe façon troublante, %anatomist% lève son poing et l\'enfonce dans une des chambres du cœur. On peut voir le muscle bouger, semblant pomper et palpiter comme il l\'a peut-être fait autrefois. Il retire sa main et regarde la crasse qui s\'y trouve: des tissus noirs, une couche de moisissure, du sang séché.%SPEECH_ON%Ce spécimen sera très utile pour nos études.%SPEECH_OFF%Il vous regarde comme attendant une confirmation de votre part. Vous regardez la brouette lestée et vous lui dites que si c\'est son spécimen à partir de maintenant, c\'est sa colonne vertébrale qui sera brisée en le transportant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "N\'oubliez pas, c\'est les genoux qu\'il faut plier.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/unhold_heart_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Gland",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Pour vous, cet achat ressemble à des pépites cendrées enroulées les unes autour des autres. Des bosses grises se courbent et s\'aplatissent à plusieurs reprises sur l\'organe, tandis que ses muscles se contournent et se tordent comme les cordes d\'un matelot. Les ondulations se terminent par un gros bulbe de tissu.%anatomist% explique.%SPEECH_ON%On pense que c\'est l\'organe qui donne au loup-garou tant d\'énergie. Même sa forme est de structure féroce, comme si l\'organe lui-même était prédisposé à son utilité.%SPEECH_OFF%Il coupe dans le tissu et en retire un bout, révélant un réseau de tunnels et de canaux charnus qui aboutissent à un étrange complexe de cavités. On ne sait pas à quoi peut servir cette pièce pour un humain, mais lorsque %anatomist% commence à tripoter les trous, vous partez rapidement, en le prévenant seulement de ne pas le faire en public, de peur qu\'il ne suscite dans la paysannerie une envie pressente de lynchage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et coupez vos ongles.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/adrenaline_gland_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bunk",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Quand vous revenez voir la compagnie, %anatomist% semble un peu déçu de son achat. Il essaie d\'en retirer quelque chose d\'utile, quelque chose que peut-être personne d\'autre n\'a vu auparavant, mais il semble que son projet n\'aboutisse à rien. Il se plaint qu\'il connaît déjà ces parties, qu\'elles ont déjà été écrites, et que d\'autres personnes ont déjà été rendues célèbres grâce à leurs découvertes. Vous hochez la tête en écoutant, et faites semblant de vous intéresser à lui alors qu\'il vous regarde avec des yeux tristes. Il dit.%SPEECH_ON%Cette substance est ce que les orcs mangent, parfois elle vient de l\'orc lui-même. Nous le savons depuis des années. Je pensais pouvoir en tirer quelque chose qui n\'avait pas encore été appris, mais mon excès de confiance n\'a conduit qu\'au gaspillage de couronnes.%SPEECH_OFF%Vous prenez une cuillère de poulet grillé et vous la mettez dans votre bouche. En l\'a retirant,  vous fixez votre reflet difforme sur la cuillère. En hochant la tête, vous dites.%SPEECH_ON%C\'est tellement fascinant. Avez-vous essayé de le manger?%SPEECH_OFF%L\'anatomiste fixe l\'étrange viande. Il avoue qu\'il ne pense pas que quelqu\'un l\'ait fait, du moins pas dans le but de l\'étudier. Il fixe la viande un peu plus longtemps. Il marmonne.%SPEECH_ON%C\'est pour la science n\'est-ce pas?%SPEECH_OFF%Vous prenez une autre bouchée de nourriture et hochez la tête. %anatomist% plonge sa main dans la viande étrange et en retire une côte dégoulinante de chair détrempée. Il commence à avoir des haut-le-cœur et se lève rapidement pour s\'enfuir. Vous prenez l\'étrange côte et la lancez au loin. À la seconde où elle touche le sol, une meute de chiens sauvages sort d\'une ruelle et se battent entre eux pour la manger. Vous pointez du doigt les chiens et criez après l\'anatomiste.%SPEECH_ON%Hé, je crois que je viens de faire une expérience!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Regardez-les se battre pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.5, "A promising research specimen turned out to be useless");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local food = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 650)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Price = 0;
		this.m.Town = null;
	}

});

