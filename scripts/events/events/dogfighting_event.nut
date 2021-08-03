this.dogfighting_event <- this.inherit("scripts/events/event", {
	m = {
		Doghandler = null,
		Wardog = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.dogfighting";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%%doghandler% vous demande d\'inscrire %wardog% dans un combat de chiens. Cela semble être une idée terrible, mais l\'homme continue en expliquant qu\'il y a beaucoup d\'argent à gagner dans les combats de chiens. Tout ce dont le maître-chien a besoin, c\'est d\'une avance de deux cents couronnes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, mais je viens avec vous.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ça n\'arrivera pas.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Vous prenez une bourse de couronnes et suivez %doghandler% à travers un dédale de rues de plus en plus sombres. Très vite, il n\'y a plus grand-chose à voir. Les pavés mouillés, léchés à blanc par les éclairs de la lune, vous guident paresseusement vers les profondeurs que la ville cache à ceux qui préfèrent le jour. Soudainement, une torche s\'allume et le visage d\'un homme, flottant et désincarné dans l\'obscurité, vous parle.%SPEECH_ON%Ce chien est ici pour les combats ?%SPEECH_OFF%%doghandler% fait un signe de tête. L\'étranger incline la torche vers l\'avant.%SPEECH_ON%Très bien alors. Par ici, mes-ssi-eurs. Faites attention où vous mettez les pieds. Toutes les sortes de pisse dégoulinent sur le sol.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faisons ça.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "J\'ai changé d\'avis.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%En suivant la torche de l\'homme dans l\'obscurité, vous arrivez à un bâtiment avec un portail coulissant en tant que porte. L\'étranger frappe plusieurs fois à la porte et elle s\'ouvre comme si elle avait été commandée par le dernier coup. On vous fait entrer, des visages dédaigneux vous observent de côté pendant que vous entrez. Immédiatement, vous entendez le vacarme inquiétant des grognements et des aboiements. C\'est pour ça que vous êtes là, non ?\n\nDes escaliers vous mènent aux fosses où une foule se presse autour d\'une arène de fortune faite de terre et de poteaux de clôture branlants. On ne peut pas encore voir l\'action, mais sur le côté, il y a un tas de chiens morts et à côté d\'eux sont assis leurs tueurs, les yeux fous, le sang écumant dégoulinnante de leurs gueules ouverte dans un halètement horrifié. Alors que deux chiens s\'affrontent dans l\'arène, vous jetez un coup d\'œil à %doghandler%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est temps d\'augmenter les enchères et de voir ce que notre clébard peut faire.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "C\'est mauvais. Partons d\'ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_47.png[/img]Après avoir payé la mise de deux cents couronnes, vous et %doghandler% emmenez %wardog% dans l\'arène.\n\nSes yeux s\'agitent et lorsque son épaule s\'appuie sur votre pantalon, vous sentez votre cœur s\'accélérer. En face de vous se trouve votre concurrent : un maître-chien à l\'allure douteuse et une bête massive qui tient plus du loup que du chien. Le molosse n\'a plus de lèvre inférieure, laissant apparaître une rangée de dents déchiquetées qui ont été taillées pour être plus mortelles qu\'elles ne le sont déjà. Des croûtes et des plaies tachent son corps tordu, mais la musculature de sa structure est apparente et %doghandler% murmure que ça va être moche.\n\n %wardog% a été élevé pour la guerre, et d\'une main tendue, vous lâchez votre chien au moment où votre adversaire fait de même.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attrape-le, mon garçon !",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "E";
						}
						else if (r <= 66)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_47.png[/img]Les deux chiens sprintent l\'un vers l\'autre et traversent la petite arène en un éclair. Ils se heurtent, leurs corps grossiers s\'écartant l\'un de l\'autre avant que leurs pieds ne se plantent et ne se lancent dans une nouvelle attaque. Le chien de l\'adversaire s\'esquive sous le %wardog% puis se relève, s\'accrochant à la partie inférieure du cou de votre chien.\n\nLes mains de %doghandler% s\'approchent de son visage, ses yeux regardant entre ses doigts. Vous regardez %wardog% être secoué d\'un côté à l\'autre. Le sang gicle de son nez et il glapit. Vous pouvez entendre le bruit des pattes qui s\'entrechoquent, impuissantes, alors que le chien tente de donner des coups de pattes sur la terre. Le public ricane et rit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne peux pas intervenir.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "H" : "I";
					}

				},
				{
					Text = "Il faut que cela cesse !",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_47.png[/img]Les deux chiens sprintent à travers l\'arène. %wardog% va en haut, et son adversaire vers le bas. Vous regardez avec horreur le chien de l\'adversaire qui se lève de sa position basse et serre ses mâchoires sous le cou de %wardog%. Ils tombent à travers l\'arène et dans le violent élan, la gorge de %wardog% est arrachée. Le sang gicle si fort que le public saute en arrière pour s\'éloigner. Le bâtard victorieux retourne vers son propriétaire et dépose un morceau de chair et de muscle à ses pieds.\n\n%wardog% trébuche sur la terre. Il a du mal à respirer, sa gorge se plisse, sa respiration est sifflante. %doghandler% saute la clôture et s\'agenouille à côté du chien. Il essaie de couvrir la blessure, mais c\'est inutile. Le chien vous regarde fixement pendant qu\'il meurt.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merde !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " meurt."
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_47.png[/img]Les deux chiens grognent brièvement avant de charger. Ils entrent en collision et s\'accrochent simultanément au cou l\'un de l\'autre, tournant en spirale dans l\'arène comme une sorte de roue à picots violente et poilue.\n\n%wardog% envoie son adversaire dans un poteau de clôture. Vous regardez votre chien enfoncer ses mâchoires dans le visage de son adversaire, lui enfonçant ses dents dans un œil d\'un coup et lui arrachant un morceau de langue d\'un autre coup. Le cabot vaincu est littéralement mis en pièces et, alors qu\'il s\'écroule, votre chien s\'engage à lui arracher la gorge.\n\nVotre adversaire crie et tente de sauter la barrière, mais le public le fait reculer. %doghandler% vous tape dans le dos.%SPEECH_ON%De l\'argent facile, non ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il semblerait que la compagnie possède également les chiens les plus méchants.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_47.png[/img]Vous décidez de ne pas intervenir et de laisser le combat et la mort potentielle de %wardog% se dérouler comme il devra se terminer. Ce choix est vite récompensé : vous voyez votre chien poser ses pattes arrière contre l\'un des poteaux de clôture qui entourent l\'arène. Avec un bon coup de pied, il parvient à se glisser sous son adversaire et dans une démonstration dégoûtante de survie lui arrache les testicules qui pendent . Le pauvre bâtard émasculé, hurlant, se retourne pour se retrouver le cou directement dans les mâchoires de %wardog%. Le combat s\'achève rapidement, et presque miraculeusement, à partir de là.\n\nVous allez chercher votre récompense pendant que %doghandler% fait un câlin à %wardog% qui remue la queue.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon chien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_47.png[/img]Vous n\'intervenez pas et devez même retenir %doghandler% alors que l\'homme tente de sauter la clôture. Tous les deux, vous ne pouvez que regarder avec horreur les morsures féroces du bâtard qui arrachent morceau par morceau le visage de %wardog%. Bientôt, votre chien s\'effondre sur le sol, donnant son cou. Des déchirures sanglantes s\'ensuivent et %wardog% devient très vite un chien mort. Désemparé, %doghandler% ne peut que s\'affaler sur le sol et se couvrir le visage.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merde !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " meurt."
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_20.png[/img]Vous jetez votre ticket de pari dans la boue.%SPEECH_ON%Va te faire foutre !.%SPEECH_OFF%D\'un bond, vous sautez la barrière et courez dans l\'arène. %doghandler% est juste derrière vous. Les deux chiens sont toujours en train de se battre, mais un coup de pied rapide vous les séparés. Le maître-chien attrape rapidement %wardog% et le soulève hors de danger. La foule hue, les bouteilles et les verres commencent à voler. Un homme souffle dans un sifflet qui les fait tous taire. Il entre dans l\'arène.%SPEECH_ON%Ces gens ont payé pour voir du sang. Si vous n\'allez pas le leur donner, alors vous feriez mieux de trouver un autre moyen de payer. Que diriez-vous de deux cents couronnes ? Ça ou vous allez de l\'avant et remettez ce chien à terre.%SPEECH_OFF%La foule fait craquer leur articulation et sort des couteaux, des chaînes et d\'autres armes grossières.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez vos satanées couronnes, alors. Nous partons avec notre chien.",
					function getResult( _event )
					{
						return "K";
					}

				},
				{
					Text = "Le combat va continuer.",
					function getResult( _event )
					{
						return "L";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_20.png[/img]Vous sortez %demand% couronnes et vous les remettez. La foule hue, mais le responsable donne un nouveau coup de sifflet.%SPEECH_ON%Fermez-la, tous autant que vous êtes ! L\'homme a payé la taxe pour qu\'il puisse partir avec son stupide chien.%SPEECH_OFF%La foule se calme. Vous commencez à partir, %doghandler% derrière vous avec %wardog% inconscient dans ses bras. Quelques clients sifflent et crachent, mais c\'est à peu près tout ce qu\'ils font et cela vous convient parfaitement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons au camp...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_20.png[/img]Vous ordonnez à %doghandler% de poser le chien. Ses yeux s\'écarquillent.%SPEECH_ON%Tu n\'es pas sérieux.%SPEECH_OFF%En hochant la tête, vous dites que vous l\'êtes. %wardog% est à peine réveillé, il grogne entre une vigilance effrayée et une inconscience étouffée. Lorsque %doghandler% hésite à nouveau, vous attrapez le chien et l\'éloignez. Vous faites un signe de tête à la foule, puis à votre adversaire qui lâche son chien meurtrier une seconde fois. Les yeux larmoyants et fatigués de %wardog% vous regardent, clignotent, puis se ferment. Vous posez le chien, le molosse de votre adversaire s\'abat sur lui avec une fureur bestiale. Vous essayez de ne pas écouter l\'horrible destin qui se déroule à vos pieds.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retournons au camp...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " meurt."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 250)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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
		local candidates = [];

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Doghandler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Wardog = this.m.Doghandler.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"doghandler",
			this.m.Doghandler.getNameOnly()
		]);
		_vars.push([
			"wardog",
			this.m.Wardog.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"demand",
			"200"
		]);
	}

	function onClear()
	{
		this.m.Doghandler = null;
		this.m.Wardog = null;
		this.m.Town = null;
	}

});

