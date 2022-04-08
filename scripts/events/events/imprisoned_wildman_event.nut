this.imprisoned_wildman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Wildman = null,
		Monk = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.imprisoned_wildman";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]Pendant la marche, vous rencontrez une file de wagons arrêtés. Vous vous rendez compte que les wagons sont des cages servant chacune de prison à un animal sauvage. En parcourant la file de charrettes, vous voyez une grande variété de bêtes. Un chat noir voûté et miaulant lance ses griffes de tueur d\'hommes à travers les barreaux. En sursautant, vous bousculez une autre cage qui vibre violemment du rugissement d\'un ours. Heureusement, ses pattes puissantes sont trop grosses pour tenir entre les barreaux. Une autre cage grésille avec le sifflement des serpents.\n\n Un homme se penche derrière l\'un des chariots. Il a un regard sauvage sur son visage comme si vous veniez de le surprendre en train de se masturber.%SPEECH_ON%Hey ! Qui êtes vous? Que faites-vous ici ?%SPEECH_OFF%Vous informez l\'inconnu que vous êtes le capitaine de la %companyname%. L\'homme se redresse.%SPEECH_ON%Oh, mercenaire alors ! Et j\'ai pensé que ma chance s\'était envolée ! Écoutez, j\'ai un problème pour lequel mes employés ont refusé de m\'aider. Ils s\'en fichaient quand ils n\'en savaient pas plus, mais cette satané bâche est tombé du wagon et ils ne parlent que du fait que je ne les payais pas assez pour transporter de telles marchandises !%SPEECH_OFF %",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Avec quoi avez vous besoin d\'aide?",
					function getResult( _event )
					{
						return this.World.Assets.getOrigin().getID() != "scenario.manhunters" ? "B" : "B2";
					}

				},
				{
					Text = "Ce n\'est pas notre problème.",
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
			Text = "[img]gfx/ui/events/event_100.png[/img]Le dompteur d\'animaux vous conduit jusqu\'à une calèche. Vous voyez immédiatement pourquoi ses mercenaires ont démissionné : un homme sauvage frénétique et haineux est assis à l\'intérieur de la cage. Des poignets à vif saignent contre ses chaînes, signes de tentatives d\'évasion. À moitié affamé, l\'homme sauvage ronge des bâtons qui sortent de sa barbe broussailleuse. Voyant ce triste spectacle, vous attrapez l\'étranger par sa chemise et le plaquez contre le chariot.%SPEECH_ON%Cela ressemble-t-il à un animal pour vous ?%SPEECH_OFF%Le dompteur d\'animaux sourit, l\'ivoire en guise de dents. Il s\'explique.%SPEECH_ON%Les citadins ont eu vent des hommes sauvages \'non civilisés\' et souhaitent les voir de près. Je ne fais que répondre à cette nouvelle demande comme le ferait n\'importe quel homme d\'affaires. Maintenant, tout ce dont j\'ai besoin, c\'est pour sortir ce cadavre de la cage.%SPEECH_OFF%Il pointe vers un cadavre dans un coin. L\'homme sauvage recule en grognant et va s\'asseoir de manière protectrice sur le corps. Le dresseur d\'animaux secoue la tête.%SPEECH_ON%L\'un de mes assistants s\'est trop approché et, eh bien, ouais. Je ne peux pas aller en ville avec ce gâchis là-dedans alors j\'ai pensé que vous pourriez peut-être m\'aider à le récupérer. Je paierai beaucoup, bien sûr. Une bourse de 250 couronnes vous convient ? Il suffit d\'entrer à l\'intérieur et de retirer ce corps.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Très bien, je vais envoyer un homme.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Nous avons notre propre homme sauvage qui pourrait nous aider.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Notre moine semble un peu troublé par cela.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "Je ne mettrai pas la vie de mes hommes en danger pour ça.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_100.png[/img]Le dompteur d\'animaux vous conduit jusqu\'à une calèche. Vous voyez immédiatement pourquoi ses mercenaires ont démissionné : un homme sauvage frénétique et haineux est assis à l\'intérieur de la cage. Des poignets à vif saignent contre ses chaînes, signes de tentatives d\'évasion. À moitié affamé, l\'homme sauvage ronge des bâtons qui sortent de sa barbe broussailleuse. Voyant ce triste spectacle, vous attrapez l\'étranger par sa chemise et le plaquez contre le chariot.%SPEECH_ON%Cela ressemble-t-il à un animal pour vous ?%SPEECH_OFF%Le dompteur d\'animaux sourit, l\'ivoire en guise de dents. Il s\'explique.%SPEECH_ON%Les citadins ont eu vent des hommes sauvages \'non civilisés\' et souhaitent les voir de près. Je ne fais que répondre à cette nouvelle demande comme le ferait n\'importe quel homme d\'affaires. Maintenant, tout ce dont j\'ai besoin, c\'est pour sortir ce cadavre de la cage.%SPEECH_OFF%Il pointe vers un cadavre dans un coin. L\'homme sauvage recule en grognant et va s\'asseoir de manière protectrice sur le corps. Le dresseur d\'animaux secoue la tête.%SPEECH_ON%L\'un de mes assistants s\'est trop approché et, eh bien, ouais. Je ne peux pas aller en ville avec ce gâchis là-dedans alors j\'ai pensé que vous pourriez peut-être m\'aider à le récupérer. Je paierai beaucoup, bien sûr. Une bourse de 250 couronnes vous convient ? Il suffit d\'entrer à l\'intérieur et de retirer ce corps.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Très bien, je vais envoyer un homme.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Nous avons notre propre homme sauvage qui pourrait nous aider.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Notre moine semble un peu troublé par cela.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "Je ne mettrai pas la vie de mes hommes en danger pour ça.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% est celui chargé de nettoyer le terrarium du cadavre de l\'assistant. Il retrousse ses manches et s\'approche de la cage avec les deux mains tendus.%SPEECH_ON%Whoa là, doucement maintenant. Facile !%SPEECH_OFF%L\'homme sauvage se lève du cadavre et va de l\'autre côté de son habitat. Le mercenaire attrape facilement la botte du cadavre et la traîne vers les barreaux. Il s\'y glisse avec une facilité écœurante, déjà froissé à la manière de vêtements mouillés abandonnés. Les tripes et les membres sautillent du bord de la plate-forme du chariot. Le dompteur d\'animaux applaudit joyeusement.%SPEECH_ON%Merci beaucoup ! Et vous avez fait en sorte que cela ait l\'air si facile, en plus !%SPEECH_OFF%%taskedbro% regarde le cadavre en réalisant que cela aurait pu facilement être lui.%SPEECH_ON%Ouais. De rien.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, au moins, nous avons été payés.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(250);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous obtenez [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Couronnes"
				});
				_event.m.Other.getBaseProperties().Initiative += 2;
				_event.m.Other.getBaseProperties().Bravery += 1;
				_event.m.Other.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Other.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Other.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% est chargé de sortir le cadavre du chariot. Il s\'approche de la cage comme une prostituée arpentant une ville particulièrement pieuse. Quand il se rapproche des barres, il sourit comme un vieil ami.%SPEECH_ON%Salut mon pote. C\'est un beau cadavre que vous avez là. Un grand cadavre, vraiment l\'un des meilleurs que j\'ai jamais vus. Que diriez-vous que je... le retire... %SPEECH_OFF%Lorsque le mercenaire arrive, l\'homme sauvage bondit. C\'est trop rapide pour même le voir. %taskedbro% se retourne lentement. Il y a un trou noir là où se trouvait l\'un de ses yeux. L\'homme sauvage écrase l\'œil entre ses dents, une glu blanche jailli comme une pustule éclatée, et elle se transforme en une pâte vaporeuse pendant qu\'il mâche. Le dresseur d\'animaux vous lance un sac de couronnes et s\'enfuit.%SPEECH_ON%Non responsable ! Je ne suis pas responsable !%SPEECH_OFF%%taskedbro% s\'évanouit alors que quelques frères vengeurs poignardent à mort l\'homme sauvage emprisonné. Toutes les bêtes en cage rugissent comme si vous veniez de tuer leur chef. Vous ordonnez rapidement aux hommes de s\'éloigner de la caravane avant qu\'une de ces bêtes ne se libère et ne cause plus de dégâts.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que diable!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.missing_eye",
						Threshold = 0.0,
						Script = "injury_permanent/missing_eye_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " souffre d\' " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_100.png[/img]Vous dites à ce dompteur d\'animaux que ses problèmes sont les siens. Il hausse les épaules.%SPEECH_ON%Ouais, je ne vous blâme pas. Vous êtes plus intelligent que vous n\'en avez l\'air, mercenaire.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh, Merci.",
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
			ID = "Wildman",
			Text = "[img]gfx/ui/events/event_100.png[/img]Si quelqu\'un dans le groupe pouvait aider à calmer l\'homme sauvage en cage, c\'est probablement %wildman%. Il se dirige vers la cage, regarde à l\'intérieur. Il y a un échange de hululements. Votre homme frappe les barres avec une jointure, et le prisonnier recule et hulule sombrement. Soudain, %wildman% attrape le dresseur d\'animaux par la tête et le pousse entre les barreaux. Vous allez sauver le dompteur, mais l\'homme sauvage emprisonné louvoi à travers la cage avec une terreur atavique dans les yeux. En prenant du recul pour votre propre sécurité, vous ne pouvez que regarder cet homme bestial s\'attaquer au dompteur. Les deux hommes sauvages s\'acharnent sur le visage de l\'homme. Le dompteur commotionné crie à moitié sonné.%SPEECH_ON%Je pensais que nous avions un accordeeeeemeeeaahh!%SPEECH_OFF%%wildman% enfonce ses pouces dans les yeux de l\'homme pendant que le sauvage emprisonné saisit la bouche du dompteur et tire vers le bas. Sa tête est littéralement déchirée par les coutures et les tendons. Quelques hommes vomissent alors que la cervelle du dompteur tombe là où sa langue devrait être, une façon vraiment horrible de dire ce que l\'on pense. Le \'gardien\' pris en charge, %wildman% vous regarde ainsi que l\'homme-sauvage avec une sorte de geste \'pouvons-nous le garder ?\'.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolument dégoûtant. Il est parfait.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "Non, il est clairement beaucoup trop dangereux.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Wildman1",
			Text = "[img]gfx/ui/events/event_100.png[/img]Une capacité de violence exceptionnelle convient bien à une bande de mercenaires. Vous acceptez de prendre l\'homme sauvage emprisonné.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return "Animals";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"wildman_background"
				]);
				_event.m.Dude.setTitle("L\'animal");
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été \'sauvé\' par votre homme lors d\'une confrontation avec un dresseur d\'animaux devenu esclavagiste. Un sentiment de gratitude et de dette surmonte toutes les barrières linguistiques : l\'homme sauvage autrefois emprisonné sert loyalement la compagnie pour l\'avoir sauvé." ;
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Wildman2",
			Text = "[img]gfx/ui/events/event_100.png[/img]Vous ne pensez pas que l\'homme sauvage emprisonné s\'intégrerait dans la compagnie, mais vous le libérez néanmoins. Il tire sur sa cage comme un esprit vengeur et court vers la limite des arbres. Là, il se tient à distance, hurlant et criant jusqu\'à ce qu\'il s\'enfuie à nouveau.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suppose que c\'est sa façon de dire merci.",
					function getResult( _event )
					{
						return "Animals";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_100.png[/img]%monk% le moine s\'avance, les mains jointes, la tête penchée en avant. L\'incarnation d\'un sermon, la posture des bonnes mœurs, ou celles qui s\'égarent. Il tire le dompteur de côté.%SPEECH_ON%Les anciens dieux désapprouveraient ce que vous avez fait ici.%SPEECH_OFF%Le dompteur d\'animaux rit et s\'appuie contre la cage, croisant les bras d\'un air suffisant. Il déclare que dans le sud, ils considèrent l\'esclavage comme faisant partie de l\'ordre naturel. Le moine continue.%SPEECH_ON%Vrai, mais ni vous ni cet homme sauvage n\'êtes proches de leur mode de vie. Vous souhaitez l\'asservir en étant un étranger. Il ne comprend pas la relation qui la rend particulièrement grave et inappropriée. Ma suggestion est de le faire travailler pour vous et d\'apprendre de vous. Faites-en un ami et vous aurez un ami pour la vie%SPEECH_OFF%Les mains du sauvage emprisonné traversent les barreaux et enfoncent ses doigts dans les globes oculaires. Son visage est déchiré comme un vieux pain, deux cintres en guise de mâchoire, une langue pendante comme un serpent déraciné. %moine% vomit alors que son visage est aspergé de sang. %otherbrother% secoue la tête.%SPEECH_ON%Je dirais qu\'il s\'intégrerait parfaitement à %companyname%...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolument dégoûtant. Il est parfait.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "Non, il est clairement beaucoup trop dangereux.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				_event.m.Monk.worsenMood(1.0, "Secoué par la violence dont il a été témoin");

				if (_event.m.Monk.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Animals",
			Text = "[img]gfx/ui/events/event_47.png[/img]Eh bien, le dompteur d\'animaux est parti et avec lui, il n\'y a plus personne pour s\'occuper des bêtes. %randombrother% arrive et demande ce qu\'il faut faire d\'eux.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Laissez-les sortir.",
					function getResult( _event )
					{
						return "AnimalsFreed";
					}

				},
				{
					Text = "Massacrez-les tous.",
					function getResult( _event )
					{
						return "AnimalsSlaughtered";
					}

				},
				{
					Text = "Laisse-les.",
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
			ID = "AnimalsFreed",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous pensez qu\'il ne serait tout simplement pas juste de les laisser mourir de faim ici. Vous décidez de les laisser sortir de leur cage. La plupart de ces créatures étranges se dirigent droit vers la limite des arbres, mais deux restent derrière : un chien husky et un faucon à capuchon, tous deux apparemment à la recherche d\'un maître.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous vous intégrerez tous les deux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				item = this.new("scripts/items/accessory/falcon_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez un " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "AnimalsSlaughtered",
			Text = "[img]gfx/ui/events/event_14.png[/img]Ce serait un crime de laisser ces animaux mourir de faim et pourrir. Et ce serait aussi un terrible gaspillage de bonne viande. Vous faites massacrer les créatures. C\'est un travail facile, bien que brutal, de poignarder et de trancher un tas de créatures et de bêtes malheureuses. L\'ours est le dernier à partir, et il ne s\'en va pas facilement. Il parvient à faire glisser %hurtbro% après un coup méchant, mais au-delà de cela, vos hommes l\'ont tué d\'une mort lente et macabre. Le reste des wagons est retourné et pillé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pas un mauvais coup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				_event.m.Other.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Other.getName() + " souffre de blessures légères"
				});
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous obtenez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				item = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				item = this.new("scripts/items/supplies/strange_meat_item");
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_wildman = [];
		local candidate_monk = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidate_wildman.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (!bro.getSkills().hasSkill("injury.missing_eye"))
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_wildman.len() != 0)
		{
			this.m.Wildman = candidate_wildman[this.Math.rand(0, candidate_wildman.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"taskedbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Monk = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

