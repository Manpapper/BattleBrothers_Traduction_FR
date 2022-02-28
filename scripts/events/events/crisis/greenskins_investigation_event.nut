this.greenskins_investigation_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_investigation";
		this.m.Title = "A %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]Pendant que vous réapprovisionnez votre inventaire et accordez un peu de repos aux hommes, le seigneur du château, %noble%, vous appelle. Il dit qu\'il y a un gobelin en liberté dans le château et qu\'il veut que vous le traquiez.%SPEECH_ON%Je demanderais à mes hommes, mais ils ne pourraient pas trouver leurs propres culs même s\'ils se mangeaient les yeux et les chiaient.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Nous allons fouiller le garde-manger.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B1";
						}
						else
						{
							return "B2";
						}
					}

				},
				{
					Text = "Nous allons fouiller les couloirs.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "E1";
						}
						else
						{
							return "E2";
						}
					}

				},
				{
					Text = "Nous allons fouiller l\'armurerie.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "H1";
						}
						else
						{
							return "H2";
						}
					}

				},
				{
					Text = "Nous n\'avons pas le temps pour des faveurs.",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(-5.0, "Refuse à " + _event.m.Noble.getName() + " une faveur");
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous fouillez le garde-manger, ouvrant la porte sur des étagères de produits alimentaires allant des fromages aux viandes salées en passant par les légumes qui pendent à des crochets muraux. Les bonbonnes en osier vous tentent, mais juste au moment où vous tendez la main pour goûter, une forme traverse votre vision périphérique. Vous vous retournez, lame à la main, et poignardez le gobelin au moment où il se précipite vers vous avec une bouteille cassée. Il meurt instantanément et fait un sacré bazar sur le sol, ruinant quelques sacs de farine. Le peau verte tuée, vous le traînez calmement vers %noble%. Le noble met ses mains sur ses hanches.%SPEECH_ON%Très impressionnant, mercenaire, mais pourquoi avez-vous dû le traîner jusqu\'ici ? Mes domestiques vont devoir récurer le sol pendant des semaines !%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'était facile. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A rendu service à " + _event.m.Noble.getName());
				local food = this.new("scripts/items/supplies/wine_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous gagnez du Vin"
				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous descendez dans le garde-manger et ouvrez la porte. À l\'intérieur, vous trouvez des étagères d\'aliments et de marchandises. Il se trouve aussi qu\'il y a un homme et une femme qui baisent dans un coin. Ils jappent comme deux chiots et se couvrent, l\'homme utilisant un sac de farine humide, la femme se penchant stratégiquement derrière une étagère de melons. L\'homme s\'éclaircit la gorge.%SPEECH_ON%S\'il vous plaît, monsieur, ne le dites pas à %noble%.%SPEECH_OFF%Vous ne saviez même pas qu\'il s\'agissait de la femme du noble, mais c\'est bon à savoir. L\'homme propose un marché.%SPEECH_ON%Écoutez, je ne suis qu\'un garçon d\'écurie. Je ne peux pas t\'offrir d\'or ou rien de ce genre, mais un célèbre jouteur reste ici une semaine et je peux t\'attraper son bouclier. C\'est une jolie chose et vous allez l\'adorer, je vous le promets. Tout ce que je demande, c\'est que vous ne le disiez pas au seigneur !%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Votre seigneur en entendra parler. ",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Votre secret est en sécurité avec moi. ",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_31.png[/img]Cela semble être le meilleur moment pour développer une relation stable avec %townname%, et la meilleure façon de procéder est de ruiner absolument cette relation sur laquelle vous êtes tombé. Vous retournez dans la chambre de %nobleman% et rapportez vos découvertes. Son visage devient rouge, ses jointures d\'un blanc éclatant.%SPEECH_ON%J\'y ai pensé. J\'y ai pensé. J\'avais compris ! Mais le garçon d\'écurie ? Je ne me laisserai pas autant insulté !%SPEECH_OFF%Il fait claquer ses doigts vers ses gardes.%SPEECH_ON%Apportez-moi des pinces et un feu de forgeron. Emmenez ma \'femme\' dans la tour. Je m\'occuperai d\'elle plus tard. Et vous, mercenaire, merci de m\'avoir apporté cette nouvelle. Quant au gobelin, il a été trouvé et pris en charge. Vous n\'avez plus à vous en soucier.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Une méthode sauvage contre l\'adultère",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A rendu service à " + _event.m.Noble.getName());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous décidez de ne pas dire au noble ce que fait sa femme. Les deux tourtereaux s\'habillent et se précipitent hors du garde-manger, le garçon d\'écurie s\'arrête pour vous dire qu\'il aura ce bouclier lorsque vous quitterez le château. En attendant, vous faites votre rapport au seigneur qui vous retient d\'une main.%SPEECH_ON%Ah, vous n\'avez plus à vous inquiéter, mercenaire. Le gobelin a été retrouvé dans les écuries. L\'un des chevaux l\'a propulsé, d\'un coup de pied, à travers la grange ! Je vais devoir récompenser le garçon d\'écurie pour les capacités militaires de ses montures !%SPEECH_OFF%Hmm, bien sûr.\n\n Lorsque vous quittez le château, le garçon d\'écurie est là, un sac en forme de bouclier suspect dans les mains.%SPEECH_ON%Tenez, prenez ça. pressez-vous. Et merci encore, mercenaire.%SPEECH_OFF%Vous lui dites que ce serait mieux s\'il la gardait dans son pantalon à partir de maintenant. Il secoue la tête.%SPEECH_ON%Non. Elle en vaut la peine. A plus tard, mercenaire.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Certains hommes n\'apprennent jamais.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/shields/faction_heater_shield");
				item.setFaction(_event.m.NobleHouse.getBanner());
				item.setVariant(2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous explorez les couloirs pour voir si le petit avorton vert se promène. En marchant dans un couloir, vous entendez le cri de deux femmes venir d\'une pièce voisine. Vous dégainez votre épée et faites irruption. Un scribe et un trésorier se tiennent sur un bureau tandis qu\'un petit gobelin saute pour essayer de leur poignarder les chevilles. Vous entrez avec désinvolture et plantez le peau verte dans la poitrine et le soulevez comme un écureuil en brochette. Les hommes se calment et vous remercient pour votre travail. Vous acquiescez.%SPEECH_ON%À plus tard, mesdames.%SPEECH_OFF%Ils s\'éclaircissent la gorge et offrent des sourires nerveux. Tu retournes chez %noble% et tu reçois ta paie.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'était facile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A rendu service à " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous gagnez [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous pensez que les halls sont un aussi bon endroit que n\'importe quel autre pour commencer votre recherche. Pas plus de quelques instant plus tard, vous entendez un bruit inquiétant venant du trésor. Dégainant votre lame, vous vous placez à côté de la porte, puis vous l\'ouvrez, sondant avec votre arme tout ce qui se trouve de l\'autre côté. Au lieu d\'un gobelin, vous trouvez un jeune et un vieux qui sursautent de peur, chacun avec un pantalon bien baissé, et il y a un pot de beurre renversé sur le bureau contre lequel ils s\'étaient appuyés. La pièce sent... affreux.\n\n S\'habillant, le plus jeune déclare qu\'il est le trésorier tandis que l\'aîné vous informe de sa position de scribe. Le trésorier vous offre rapidement une bonne somme d\'argent pour garder le silence sur ces sujets délicats. Vous riez.%SPEECH_ON%Je ne tomberai pas dans le piège. Si je prends cette pièce, vous n\'avez qu\'à courir vers votre seigneur et lui dire que je l\'ai volée, non ? Quoi de mieux pour se protéger que d\'assurer mon exécution ?%SPEECH_OFF%Le trésorier recule et le scribe s\'avance. C\'est un vieil homme qui sent la merde et la cire de bougie.%SPEECH_ON%Dans mon logement, j\'ai beaucoup de choses qui m\'appartiennent, et non à mon seigneur. Ces articles pourraient vous intéresser. Des potions, des boissons, des biens dont un combattant tel que vous pourrait se servir. Et... et je vais ajouter un chien de garde ! Un maître-chien local me doit une faveur et c\'est maintenant le meilleur moment pour lui rappeler !%SPEECH_OFF%Le scribe rit nerveusement pendant que vous réfléchissez à l\'idée. Si vous les dénoncez, qui sait ce qui peut arriver. Les sodomites ne vous dérangent pas, mais il y a des seigneurs à travers le royaume qui considèrent de telles fornications comme odieuses. Si %noble% est un tel type, vous pourriez gagner des faveurs en \'menaçant\' ces hommes.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Le seigneur du château décidera de votre sort.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Votre secret est en sécurité avec moi.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous fermez la porte du placard et vous vous précipitez chez %noble%. Vous expliquez au noble ce que vous avez vu. Lorsque vous avez terminé, il déclare que le gobelin a été retrouvé noyé dans un ruisseau d\'égout et qu\'il a été mis hors d\'état de nuire.%SPEECH_ON%Quant aux sodomites, qu\'en est-il ? Avez-vous regardé autour de vous ? Un fort est un endroit absurde pour les pulsions d\'un homme. Entasser des bites à perte de vue et nulle part où les mettre. Est-ce que j\'aime ça? Non bien sûr que non. Un non-sens absolument dégoûtant, vraiment. Mais si je punissais chaque fautif, je me retrouverais avec un tas d\'épouvantails et d\'animaux de ferme, et je ne peux même pas être sûr de ces dernier.%SPEECH_OFF%Il vous fait signe de partir.%SPEECH_ON%Le gobelin On s\'en est occupé, merde, je n\'ai pas grand-chose d\'autre à vous dire. Cependant, si vous le pouviez, veuillez informer les domestiques que la pièce dans laquelle vous les avez trouvés a besoin d\'être nettoyée. Je me soucie de ne pas regarder les impôts dans un nuage de merde.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oh.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous décidez de garder leur secret au prétexte que le scribe vous donnera ce qu\'il a promis. Le vieil homme hoche la tête alors que vous partez.%SPEECH_ON%Je vous trouverai dans la cour, merde, avec tout ce qui vous est dû. Votre silence à ce sujet est très apprécié.%SPEECH_OFF%Lorsque vous revenez à %noble%, il explique que le gobelin a été retrouvé et pris en charge. Voyant que vous n\'étiez pas responsable, il vous renvoie sans solde.\n\n Dehors, le scribe vous attend effectivement. Il a une laisse dans une main et un sac dans l\'autre. Il vous les remet tous les deux.%SPEECH_ON%Encore une fois, mes remerciements, mercenaire.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Je devrais apprendre plus de secrets.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item;
				item = this.new("scripts/items/accessory/poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/accessory/berserker_mushrooms_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Si vous étiez un gobelin dans un château de personnes voulant vous tuer, où iriez-vous ? En vous mettant dans l\'esprit de l\'avorton, vous en arrivez à la conclusion que l\'armurerie serait le meilleur endroit pour commencer votre recherche. Lorsque vous y arrivez, vous trouvez un apprenti debout à l\'extérieur, essayant de maintenir la porte fermée. Il crie que le gobelin est à l\'intérieur et qu\'il a déjà tué le forgeron. Vous dégainez votre lame et dites à l\'apprenti de s\'écarter.\n\n À la seconde où il le fait, la porte s\'ouvre brusquement et un gobelin, sort en trombe, armuré de la tête aux pieds, un bouclier et une lance maladroitement placés à l\'avant. Ignorant l\'absurdité de l\'instant, vous frappez à travers le fouillis et percez le crâne de la bête, la tuant instantanément. Lorsque vous retirez votre épée, toutes les armures et armes tombent comme si vous veniez de tuer une apparition qui les tenait debout.\n\n L\'apprenti vous serre rapidement la main avant de tomber à genoux, pleurant la perte du forgeron . Sans avoir le temps compatir, vous prenez la tête du gobelin et retournez voir %noble% pour votre salaire.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'était facile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A rendu service à " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous gagnez [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "H2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Eh bien, si vous étiez un petit nain dans une forteresse hostile, le premier endroit où vous iriez serait l\'armurerie. Lorsque vous y arrivez, vous ne trouvez aucun gobelin, mais à la place, il y a un enfant qui retire un poignard d\'un homme qui est face contre terre. Le meurtrier laisse tomber son arme et lève les mains.%SPEECH_ON%Je n\'avais pas le choix ! Pas le choix du tout !%SPEECH_OFF%Vous demandez au gamin qui sont il, lui et le mort. Il explique rapidement.%SPEECH_ON%Je suis  son apprenti et c\'est... était le forgeron. Maintenant, cela devait être fait. Devait! Vous n\'avez aucune idée des horreurs que cet homme m\'a infligées ! Chaque fois que je me trompais, il me punissait comme si j\'étais un crétin tueur de rois ! Tu vois ça ?%SPEECH_OFF%Il écarte une mèche de cheveux, révélant les cicatrices bulbeuses des brûlures. Lâchant les cheveux, il lève une main avec un petit doigt grotesque qui repose à angle droit, et l\'autre main qui n\'a pas de petit doigt du tout. Il commence à enlever une botte, mais vous l\'arrêtez, vous comprenez. L\'apprenti joint ses mains ensemble, son petit doigt dépassant comme un hautain sirotant du vin.%SPEECH_ON%Vous êtes après le gobelin, n\'est-ce pas ? Dites-leur juste que c\'est le gobelin qui l\'a fait ! Je vais... écoutez, je ne suis pas vraiment un armurier, mais je peux forger une épée comme personne ne le fait et je vais vous forger le meilleur de ce que je peux faire. Gardez juste ce secret entre nous, c\'est tout ce que je demande.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Un tel crime ne peut rester impuni !",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Ton secret est en sécurité avec moi.",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous fermez la porte et la verrouillez, vous assurant que le meurtrier ne pourra pas s\'enfuir. Alors que l\'apprenti crie et frappe contre la porte, vous revenez vers le noble.\n\n %noble% écoute votre rapport et hoche la tête.%SPEECH_ON%Mmhmm, oui. Le forgeron n\'est pas le premier à tomber entre les mains de ce garçon - nous avons eu une série de meurtres ici, mais nous n\'avons jamais pu trouver le coupable. Beaucoup l\'ont cru parce qu\'il s\'était cogné les mains avec des marteaux et avait mis son visage contre une torche. Le garçon d\'écurie l\'a même vu couper la bite d\'un rat. C\'était un type dérangé, mais maintenant vous nous avez donné la preuve définitive de ses agissements. Bravo, merde ! Le gobelin que vous recherchiez a déjà été pris en charge, mais ça... c\'est bien plus utile que de traquer des Peaux-Vertes. Considérez votre paiement comme doublé !%SPEECH_OFF%Le noble fait claquer des doigts vers son scribe et commence à donner des ordres, émettant ostensiblement un bref ordre d\'exécution. Il entre dans des détails incroyables sur la logistique de l\'affaire : des chevaux, des cordes, des lames, des pinces, des feux brûlants, une litanie d\'horreurs pour divertir les soldats ennuyés pendant des heures.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Très bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A rendu service à" + _event.m.Noble.getName());
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous gagnez [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_31.png[/img]Vous décidez de garder son secret au prétexte que le gamin vous donnera une belle épée. %SPEECH_ON%Je vous trouverai dans la cour, merde, avec ce qui vous est dû. Votre silence à ce sujet est très apprécié.%SPEECH_OFF%Lorsque vous revenez à %noble%, il explique que le gobelin a été retrouvé et pris en charge. Voyant que vous n\'étiez pas responsable, il vous renvoie sans solde, vous lui glissez un mot sur le sort de l\'armurier. Le noble hoche la tête et vous fait signe de partir.\n\n Dehors, le gamin vous attend effectivement. Il a une magnifique épée dans les mains. Il vous la remet.%SPEECH_ON%Encore une fois, merci, mercenaire!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Très bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestTown;

		foreach( t in towns )
		{
			if (!t.isAlliedWithPlayer())
			{
				continue;
			}

			if (!t.isMilitary() || t.isSouthern() || t.getSize() < 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 4)
			{
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Noble = this.m.NobleHouse.getRandomCharacter();
		this.m.Town = bestTown;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Noble = null;
		this.m.Town = null;
	}

});

