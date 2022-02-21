this.greenskins_pet_goblin_event <- this.inherit("scripts/events/event", {
	m = {
		HurtBro = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_pet_goblin";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]En marchant dans la forêt, vous arrivez dans une clairière où se trouve une petite cabane. Il y a des pièges à ours suspendus à ses murs, des peaux d\'écureuil aux avant-toits et les fenêtres sont habillées de feuilles mouillées dans leurs coins. Un vieil homme est sur le porche, se balançant sur sa chaise. Il a une arbalète braquée sur vous.%SPEECH_ON%C\'est ma propriété.%SPEECH_OFF%Il y a une chaîne allant du bras de sa chaise à une trappe au bas de la porte de la cabane. Il se déplace légèrement vers vous puis se retourne et appuie l\'arbalète contre la porte.%SPEECH_ON%Hush, toi! l\'homme à l\'épée, et tous tes amis, allez-y. Un autre pas dans le mauvais sens, sur ma propriété, et je vais te foutre ce carreau dans le cul.%SPEECH_OFF%%randombrother% se met à tes côtés.%SPEECH_ON%Que devons-nous faire, monsieur ?%SPEECH_OFF% ",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Regardons-y de plus près.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Nous n\'avons pas le temps pour les fous.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous n\'avez aucune raison de déranger davantage la journée de ce vieil homme, et vous dites donc à la compagnie de lui donner, ainsi qu\'à sa hutte, une large place. L\'aîné vous regarde avec méfiance à chaque étape du chemin.%SPEECH_ON%Mmhmm, passez une bonne journée maintenant.%SPEECH_OFF%Vous hochez la tête et répondez.%SPEECH_ON%Oui, vous aussi.%SPEECH_OFF%La chaîne bouge à nouveau et se heurte à un autre silence. Qui sait ce qui se passait ici, mais la compagnie est attendu ailleurs",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bonne journée. ",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous faites un pas en avant. Le vieil homme saute de sa chaise et crache.%SPEECH_ON%fils d\'pute%SPEECH_OFF%Il soulève l\'arbalète et la déclenche de la hanche. Le tir va large dans les arbres où il claque des branches et des feuillages. %randombrother% se précipite vers le porche et plaque l\'homme au sol.%SPEECH_ON%Enleve tes mains de putain, toi, toi, putain !%SPEECH_OFF%Pendant que l\'homme crache et donne des coups de pied, tu marches calmement vers le porche et ouvre le porte de sa hutte. La chaîne tire sur le plancher et se tend. Une forme sombre se dirige vers le coin, escaladant les murs en essayant d\'aller plus loin que ses chaînes ne le permettent. Vous prenez une torche et l\'agitez dans l\'obscurité. Là, vous voyez le prisonnier. Le vieil homme crie depuis le porche.%SPEECH_ON%Vous nous laissez seuls ! Allez-y maintenant, vous nous laissez tranquilles !%SPEECH_OFF%Là, s\'éloignant de votre torche, se trouve un gobelin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Pourquoi voudriez-vous garder un gobelin enchaîné ici ?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Mieux vaut tuer cette chose maintenant.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous faites un pas en avant. Le vieil homme saute de sa chaise et crache.%SPEECH_ON%filsdpute!, je vous avais prévenu ! Je vous ai clairement averti !%SPEECH_OFF%Il soulève l\'arbalète et la tire de la hanche. Le tir passe par-dessus votre épaule et passe à travers le bras de %hurtbro%. Le mercenaire regarde vers son bras, une plume vacillant d\'un bout du trou, un bout de manche ensanglanté se tortillant de l\'autre. Il s\'assied.%SPEECH_ON%Eh bien, amusez-vous.%SPEECH_OFF%%randombrother% crie et se précipite. Alors que le vieil homme essaie de recharger, le mercenaire repousse l\'arbalète et jette le tireur au sol. Vous dites au mercenaire de garder l\'homme en vie. Pendant que l\'homme crache et donne des coups de pied, vous marchez calmement jusqu\'au porche et ouvrez la porte de sa hutte. Lorsque la porte s\'ouvre en grand, la chaîne traverse le plancher et se tend. Une forme sombre se dirige vers le coin, escaladant ses murs en essayant d\'aller plus loin que ses chaînes ne le permettent. Vous prenez une torche et l\'agitez dans l\'obscurité. Là, vous voyez le prisonnier. Le vieil homme crie depuis le porche.%SPEECH_ON%Vous nous laissez seuls ! Partez maintenant, laissez nous tranquilles !%SPEECH_OFF%Là, s\'éloignant de votre torche, se trouve un gobelin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Pourquoi voudriez-vous garder un gobelin enchaîné ici ?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Mieux vaut tuer cette chose maintenant.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HurtBro.getImagePath());
				local injury = _event.m.HurtBro.addInjury(this.Const.Injury.PiercedArm);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.HurtBro.getName() + " souffre " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous sortez votre épée et entrez dans la cabine. Le vieil homme vous appelle. Toutes les menaces et les postures ont disparu. Il vous supplie presque maniaquement de ne pas blesser le gobelin. Mais vous faites exactement cela, enfonçant une lame dans la poitrine du peau verte. Il se soulève contre le métal, l\'agrippant de ses doigts visqueux et dégoûtants. Sa poigne s\'affaiblit à mesure que la lumière quitte ses yeux. Vous sortez la lame et essuyez le sang sur votre pantalon. Comme si le chagrin le renouvelait avec une puissance invisible, le vieil homme crie et parvient à se relever. Il sort un poignard et vient après vous, mais %randombrother% l\'arrête avec son propre dague, plantant la lame juste sous la poitrine de l\'homme. Le sang coule sur la poignée alors que son coeur bat rapidement les dernier instants de sa vie. Les genoux du vieil homme fléchissent et glissent vers le bas, agrippant les bras de son assassin.%SPEECH_ON%Créatures cruelles... cruelles...%SPEECH_OFF%Il s\'effondre sur le plancher. Vous dites à la compagnie de fouiller la cabine et de prendre ce qu\'elle peut.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Repose en paix, ermite.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_25.png[/img]En gardant le gobelin en vue à tout moment, vous demandez à l\'homme pourquoi il a un peau-verte attachée dans sa cabine. L\'ermite pleure sur le plancher.%SPEECH_ON%C\'est un ami ! Mon seul ami !%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Tu es devenu fou, ermite. Fou!",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Qui enchaîne un ami ?",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ce gobelin s\'il est libéré ne rendra compte qu\'à ses vrais amis !",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous sortez de la cabane et vous vous accroupissez devant le vieil homme. Il se tortille et supplie.%SPEECH_ON%S\'il vous plaît, ne le tuez pas !%SPEECH_OFF%L\'homme est devenu fou et vous le lui dites. Il sanglote sur le plancher du porche, son souffle projetant de la sciure de bois dans l\'air. Enfin, il reprend sa respiration et se calme.%SPEECH_ON%Vous avez raison. Je n\'est pas toute ma tête. J\'ai trouvé le gobelin dans un piège il y a quelques jours et je l\'ai recueilli, je l\'ai soigné. Je n\'ai pas de compagnie dans ces régions. On se sent seul, vous comprenez.%SPEECH_OFF%Vous ramassez et rechargez l\'arbalète, puis vous l\'offrez au vieil homme.%SPEECH_ON%Pouvez-vous le faire ?%SPEECH_OFF%Le vieil homme fixe l\'arbalète. Il cligne des yeux plusieurs fois et acquiesce. Il prend l\'arbalète et entre dans la cabine. Son esprit est fragile et il marmonne des excuses dans sa barbe. Le gobelin est recroquevillé, se protégeant de ses mains maladives.%SPEECH_ON%Je suis vraiment désolé. Tellement désolé.%SPEECH_OFF%Le vieil homme prépare l\'arbalète, glisse son doigt sur la gâchette, puis place le carreau sous son menton et tire. Il s\'effondre au sol, le coup retentit alors qu\'il claque dans le plafond, un peu de sang dégoulinant de ses plumes. Vous secouez la tête, entrez dans la cabine et tuez vous-même le gobelin. Terminé, vous dites aux hommes de fouiller la hutte et de prendre ce qu\'ils peuvent.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nom de Dieu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_25.png[/img]Prudemment, vous retournez vers le vieil homme. Vous ramassez la chaîne et l\'agitez en demandant à l\'homme.%SPEECH_ON%Un ami que vous gardez enchaîné ? Si c\'était votre véritable ami, vous n\'auriez pas besoin de chaînes, non ?%SPEECH_OFF%L\'ermite hausse les épaules.%SPEECH_ON%Vous avez raison. Laisse-moi y aller et je vais vous prouver qu\'il est un vrai ami.%SPEECH_OFF%Tu laisses l\'homme se lever et lui dis de le \"prouver\". Il essuie la poussière de ses vêtements et rentre dans la cabine. Accroupi devant la peau verte, l\'ermite tend la main.%SPEECH_ON%Salut, mon pote.%SPEECH_OFF%Alors qu\'il tend la main pour libérer le peau verte, le gobelin grogne et se lance en avant, enfonçant ses dents dans le visage de l\'homme. Vous vous précipitez dans la cabine et donnez un coup de pied au gobelin. Il atterrit contre le coin, de la chair et du sang suspendus à ses lèvres. %randombrother% transperce le visage de la créature avec une épée. Le vieil homme crie, son visage est sanglant.%SPEECH_ON%Tu avais raison, je savais que c\'était vrai, mais mon coeur... il souffre tellement.%SPEECH_OFF%Vous le regardez mieux, vous voyez un gouffre cramoisi suintant là où son nez devrait être. Alors que l\'ermite se met en boule, il montre du doigt la cabine.%SPEECH_ON%Sous les planches là-bas. Je n\'en ai plus l\'utilité.%SPEECH_OFF%Vous hochez la tête et dites à %randombrother% de soigner l\'homme. Le reste de la compagnie commence à arracher les planches pour regarder sous le sol. Après avoir obtenu ce dont ils ont besoin, vous dites aux hommes qu\'il est temps de partir. L\'ermite retourne à son rocking-chair et prend un verre. Il a les mains tournées vers le haut sur ses genoux, du sang sèche le long de ses doigts et plus de sang coule d\'une blessure qui ne manquera pas de s\'infecter. Vous pouvez entendre le sang l\'étouffer à chaque respiration.%SPEECH_ON%J\'aurais dû me cacher. C\'est ce que je fais toujours. Pourquoi ne me suis-je pas caché ?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Allez-y doucement.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMedicine() >= 2)
				{
					this.World.Assets.addMedicine(-2);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-2[/color] Materiel médical."
					});
				}

				local r = this.Math.rand(1, 4);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/named/named_spear");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/helmets/named/wolf_helmet");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/named/black_leather_armor");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous sortez de la cabine et criez après l\'homme.%SPEECH_ON%Qu\'est-ce que vous pensez faire ? Si cette chose se détache, elle courra vers le campement des peaux vertes le plus proche et apportera leur colère sur cette terre !%SPEECH_OFF%Le vieil homme fait un signe de tête vers la chaîne.%SPEECH_ON%Mon très bon ami est en sécurité, étranger, tu ne devrais pas t\'inquiétez. Vous ne savez rien de qui il est ou de son caractère !%SPEECH_OFF%Vous renversez l\'homme avec un coup de poing et vous vous accroupissez pour qu\'il vous entende bien.%SPEECH_ON%Cette chose n\'est pas votre amie. C\'est un danger.%SPEECH_OFF%Vous faites un signe de tête à %randombrother% qui entre rapidement dans la cabine et tue le gobelin d\'un coup de couteau rapide. Le vieil homme crie, le sang coagule déjà entre ses dents comme des écorces cramoisies.%SPEECH_ON%Mais pourquoi ? Qu\'est-ce qu\'il t\'a fait ? N\'avez-vous aucun honneur à tuer une créature telle que lui ?%SPEECH_OFF%Vous secouez la tête en direction du fou et ordonnez au reste de la compagnie de se déployer et de rechercher des objets. Quand ils ont fini, vous laissez le vieil homme dans sa cabane avec son ami mort.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Quel fou!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/knife");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.HurtBro = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.HurtBro.getName()
		]);
	}

	function onClear()
	{
		this.m.HurtBro = null;
	}

});

