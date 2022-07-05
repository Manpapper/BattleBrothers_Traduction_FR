this.ancient_temple_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.location.ancient_temple_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Seule la moitié de l\'entrée du temple est visible, le reste s\'étant depuis longtemps enfoncé dans le sol, comme s\'il n\'était pas sûr d\'être un cercueil ou un mausolée. Le long d\'une frise apparente, on peut voir un relief rocailleux représentant des tables renversées et des hommes riches fuyant ce qui ressemble à un squelette en armure muni d\'un fouet. Quelques mercenaires semblent mal à l\'aise à l\'idée d\'entrer, mais vous avez l\'impression que d\'autres ont ressenti la même chose et ont donc laissé l\'endroit intact.\n\n Vous sortez une torche et entrez avec l\'esprit d\'un mercenaire et la détermination d\'un voleur. Après avoir rassemblé des provisions, vous vous accroupissez et entrez dans le temple en enjambant des souches d\'arbres et en sautant sur les marches en contrebas. Le bruit de vos bottes résonne dans les salles marbrées, vous agitez la torche devant vous comme pour regarder les échos s\'en aller. En regardant en arrière, la lumière entre le sol et le sommet du temple reflète votre compagnie comme si il s\'agissait d\'une foule de sacristains satisfaits de leur travail. %volontaire% secoue la tête et dit qu\'il vient vous. Le reste de la compagnie accepte mutuellement de faire le guet.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On y va.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Oubliez ces ruines, on s\'en va.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Les parois des salles sont couvertes de mosaïques militaires si grandes qu\'elles conviennent mieux à une campagne entière qu\'à une seule bataille. Dans le hall, une parcelle en particulier s\'étend apparemment à l\'infini, une scène montrant des hommes en armure écrasant ce qui ressemble à une horde de barbares si nombreux qu\'ils perdent leur humanité et commencent à être indiscernables des insectes. Votre torche fait apparaitre, par intermittence, une vie orangée du champ de bataille réalisé par l\'artiste. Dans les coins, vous trouvez des représentations de torture et d\'indignation. Entre la garde et la foule désarticulée, il semble que l\'ordre et le chaos se soient affrontés, et si l\'ordre est sûrement destiné à gagner, c\'est le chaos lui-même qui ouvre la voie de la victoire.\n\n %volunteer% siffle. Vous regardez pour voir sa torche qui flambe au loin comme un feu follet. Vous courez vers lui pour le trouver tenant une fiole avec un étrange liquide à l\'intérieur. Le mercenaire dirige sa torche vers une alcôve dans le mur. Un poteau marbré se tient au centre et une foule de squelettes à sa base.%SPEECH_ON%J\'ai trouvé la fiole sur le piédestal là-bas. Et j\'en vois deux autres comme ça là-bas, mais elles sont derrière des portes.%SPEECH_OFF%Vous demandez au mercenaire pourquoi il ne vous a pas parlé des corps. Il hausse les épaules.%SPEECH_ON%Ils ne respiraient pas, alors je m\'en fichais. Vous voulez essayer de récupérer les deux autres flacons ou pas?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faisons-le.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Vous trouvez la fiole suivante derrière une porte à hauteur de poitrine. La fiole elle-même est tenue par la griffe d\'une gargouille de pierre sans ailes qui pend du plafond. Il y a quelques glyphes sur une dalle devant la porte, mais les inscriptions sont anciennes et même s\'elles ne l\'étaient pas, vous ne savez pas si vous seriez capable de les lire. Soudain, une voix se fait entendre.%SPEECH_ON%Une bande d\'oiseaux se trouve dans un champ lorsqu\'un chasseur arrive. Le chasseur tire une flèche et crie comme s\'il avait mal. Quelques oiseaux s\'envolent. Le chasseur les tue. D\'autres oiseaux s\'envolent, le chasseur les tue aussi et se met à pleurer en ramassant leurs corps. D\'autres oiseaux s\'envolent en l\'entendant. Le chasseur pleure et tue. Il peut à peine encocher ses flèches assez vite, il doit faire une pause pour s\'essuyer les yeux. Un oiseau se tourne vers son ami et lui dit qu\'il devrait aller consoler l\'homme. Que dit l\'ami de l\'oiseau en retour?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne t\'occupe pas de ses larmes, regarde ses mains!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Un homme au bord du gouffre doit être sauvé.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Cui. Cui-Cui?",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Quoi?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_111.png[/img]{La voix est silencieuse pendant un moment, puis reprend.%SPEECH_ON%Correct!%SPEECH_OFF%Grâce à une ingénierie ancienne, la porte coulisse et la gargouille s\'abaisse à portée de bras, le gardien fixe la fiole avec un aplomb stoïque. Vous saisissez la fiole et la serrez contre vous, comme si cette monstruosité pouvait s\'animer pour la reprendre. Vous agitez votre torche et demandez à savoir qui parle. La voix émet un rire, mais rien de plus.%volontaire% vous regarde et hausse les épaules.%SPEECH_ON%Eh bien, nous en avons une des deux, n\'est-ce pas ? Il n\'y a pas de mal à essayer de prendre l\'autre.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On va vite le savoir",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Ça a l\'air dangereux. Sortons maintenant.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Vous secouez la tête pour dire non. La première fiole était de circonstance, et était probablement le fruit d\'un échec ayant appartenu à un autre voleur. Vous avez eu de la chance. La deuxième fiole est attachée à une voix qui vous demande des conneries sans queue ni tête. Ça suffit. Vous ordonnez à %volunteer% de sortir du temple et vous partez rapidement avec les deux fioles et le bon sens de ne pas aller plus loin.\n\n Dehors, vous trouvez la compagnie %companyname% en train de donner des coups de pied et de fouet à un cadavre encore tout frais. Ils disent que l\'homme est sorti en courant du temple pendant que vous étiez en bas. Un mercenaire sort un bout de papier. Le dessin qui y figure représente les fioles, et il montre les liquides expulsant les wiedergangers comme du métal en fusion versé dans un nid de fourmis.%volunteer% rit.%SPEECH_ON%Je suppose que ça explique à quoi elles servent.%SPEECH_OFF%En hochant la tête, vous demandez si le mort avait autre chose sur lui. Un autre mercenaire hausse les épaules.%SPEECH_ON%Il est sorti par là où vous êtes entré. Il a dit : \"un homme armé, un partenaire en acier, pour vous j\'ai une énigme\", et ensuite je l\'ai abattu. Il semblait être un type dangereux.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Probablement la meilleure façon de répondre à une énigme pour le moment.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_111.png[/img]{La dernière fiole se trouve derrière une autre porte, troublante d\'un point de vue architectural. Ici, il n\'y a pas de simples barreaux de pierre, mais des flèches de fer tordues, marquées de scories. La fiole elle-même se trouve derrière sur une autre hauteur, ce qui signifie que vous devrez passer sous un mur et remonter pour l\'obtenir. La voix revient.%SPEECH_ON%De moi tout vient le commencement, De moi tout sera la fin. Quand l\'homme traverse le monde, je suis ses pas.%SPEECH_OFF%Vous gardez le silence et observez %volontaire%. Il hausse les épaules.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La poussière.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Va te faire foutre!",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Aide-moi à défoncer cette porte, %volontaire%!",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Dès que le mot sort de vos lèvres, la porte se soulève. Vous attendez pensivement qu\'elle s\'ouvre. %volunteer% s\'accroupit, passe la porte et va vers la fiole. Vous l\'imaginez aller vers la fiole tandis que les flèches du portail s\'entrechoquent dans un bruit rauque, comme si un ourse se laissait, à contre cœur, brosser les dents. L\'homme finit par pincer la fiole entre deux doigts et la fait basculer en ciseaux dans l\'étreinte sûre de sa paume. Il l\'a remet droite et dit.%SPEECH_ON%Simple, non?%SPEECH_OFF%Vous acquiescez en vous retournant avec votre torche et criez, exigeant de savoir qui parlait. Il n\'y a pas de réponse. Une brève recherche dans la pénombre ne vous permet pas de trouver de cachettes ou d\'abris, mais vous trouvez des bouts de papier et des notes avec des dessins dessus. Les pages semblent indiquer que les fioles sont capables de tuer les wiedergangers d\'un simple contact avec le liquide contenu dans chaque fiole. Il y a aussi un papier collant avec une femme dessinée grossièrement dessus. Qui que ce soit qui était là, cela n\'a pas d\'importance. Vous reprenez les flacons et retournez auprès de la compagnie %companyname%. Ils dégainent leurs épées au son de votre voix, puis les rengainent bêtement quand ils voient votre visage.%SPEECH_ON%Désolé capitaine, je vous croyais mort… et en train de marcher. Un homme mort qui marche.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, nous avons des flacons pour ça justement.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Dès que le mot sort de vos lèvres, la porte se soulève. Vous attendez patiemment la fin de l\'ouverture. %volunteer% s\'accroupit pour passer sous la porte. Vous le voyez faire tandis que les flèches du portail s\'entrechoquent dans un bruit rauque. La voix revient soudainement.%SPEECH_ON%Que j\'aille me faire foutre, et pourquoi pas toi mon pote?%SPEECH_OFF%e loquet de la porte se brise et ses pointes s\'enfoncent et transpercent le bras de %volunteer%. L\'homme crie et vous tombez à genoux pour remontez la porte d\'un coup sec. C\'est plus lourd que prévu et quand vous le lâchez, la porte se referme avec une précision déconcertante, un morceau du bras du mercenaire par-ci, un peu de sang par-là. Vous pansez la blessure et aidez l\'homme à se diriger vers la sortie, tout en agitant la torche pour éviter toute embuscade. Cependant, en sortant, vous vous arrêtez et regardez le squelette que vous avez trouvé à côté de la première fiole. Vous prenez une goutte de la fiole et la touchez du bout des doigts. Aucune réaction. Vous mettez ensuite votre doigt sur l\'un des os, il se met à grésiller et fumer. %volunteer% rit.%SPEECH_ON%C\'est pourquoi vous êtes capitaine, monsieur. Une telle intuition peut vous mener loin!%SPEECH_OFF%Vous n\'entendez plus jamais la voix mystérieuse et, sans vouloir paraître fou, vous ne faites pas référence à l\'homme mystère dans la compagnie %companyname%.\n\n Les blessures de %volunteer% ne seront mortelles. Ce n\'est qu\'un petit prix à payer pour ces anciennes fioles.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que quelqu\'un d\'autre ait payé ce prix, cependant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				local injury = _event.m.Volunteer.addInjury([
					{
						ID = "injury.pierced_arm_muscles",
						Threshold = 0.25,
						Script = "injury/pierced_arm_muscles_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Volunteer.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Volunteer.worsenMood(1.0, "Got injured navigating an ancient mausoleum");
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Vous en avez assez de cette merde. Si la voix est celle d\'un ancien ou celle d\'un bouffon, autant le savoir tout de suite. Vous faites un pas en arrière et vous brisez la porte avec votre botte. La porte se transforme en chevrons au premier coup, et se brise au second. La voix résonne de manière brève et grinçante.%SPEECH_ON%H-hey ! Vous ne pouvez pas faire ça!%SPEECH_OFF%Dégageant les pièces rouillées et les flèches acérées, vous vous accroupissez pour regarder la fiole. A ce moment-là, vous voyez un homme que vous ne connaissez pas bondir dans la petite pièce contenant la fiole. Il atterrit comme un chevreuil tombant d\'une falaise et fait tomber la flasque de son support. Vous la regardez tomber sur le sol dans un lamentable fracas de verre. Vous attrapez l\'homme par le pied et le traînez en dehors de la pièce jonchée d\'épines. il a les mains tremblantes tandis que %volunteer% presse son épée contre sa gorge.%SPEECH_ON%Je ne voulais pas dire rien par rien. Je voulais dire rien du tout. Juste rien.%SPEECH_OFF%Vous lui demandez qui il est. Vous voulez savoir si c\'est lui qui a tué les hommes dont il ne reste que les squelettes.%SPEECH_ON%Mon nom est %idiot% a-a-et ces gars-là ne sont pas des squelettes. Ce sont des morts-vivants, et ils ont reniflé cette flasque puis l\'ont descendu comme des ivrognes. Écoutez, monsieur, je ne voulais rien dire par là ! Je m\'amuse juste un peu, c\'est tout. Je ferais n\'importe quoi pour un sursis ! Enfin, presque tout.%SPEECH_OFF%Il a l\'air inquiet. Vous regardez %volunteer% qui hausse les épaules.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon, d\'accord. Vous pouvez nous rejoindre.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "K";
					}

				},
				{
					Text = "Non, ça n\'arrivera pas.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "L";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				]);
				_event.m.Dude.getSprite("head").setBrush("bust_head_12");

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

				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Les yeux de l\'homme brillent dans l\'obscurité et chaque regard est comme une braise en fin de vie.%SPEECH_ON%Vous êtes sérieux? Je peux me joindre à vous? Bien sûr.%SPEECH_OFF%Il se lève lentement, comme si une action rapide pouvait conduire à un renoncement encore plus rapide. Il vous tend la main, que vous ne serrez pas.%SPEECH_ON%MMon nom est %idiot%. J\'ai une moitié de cerveau, le reste n\'est que du bois et de la pulpe. Je suis du petit bois, bien sûr. Je plaisante. Petit bois. Tu comprends?%SPEECH_OFF%Vous regardez %volunteer% qui poignarde l\'homme dans la poitrine. Le visage de l\'idiot est crispé, il regarde l\'épée qui lui transperce le cœur.%SPEECH_ON%Hé. Je crois que vous m\'avez tué.%SPEECH_OFF%%volunteer% acquiesce.%SPEECH_ON%Oui. Je l\'ai fait. Il vous reste quelques secondes. Un discours?%SPEECH_OFF%L\'homme mystérieux réfléchit brièvement.%SPEECH_ON%Eh bien, je n\'en ai pas préparé, mais... puisque... vous... avez demandé...%SPEECH_OFF%Il meurt avant d\'avoir pu dire quoi que ce soit. Le mercenaire nettoie le sang et fouille le corps, ne trouvant que des os de rats moisis dans ses poches. Quand il lâche le cadavre, il heurte des dalles creuses. Vous vous accroupissez et touchez le crâne de l\'homme et découvrez qu\'il ne plaisante pas, il est à moitié en bois! Vous regardez %volunteer% qui hausse les épaules.%SPEECH_ON%Il aurait pu chier de l\'or pour ce que j\'en ai à faire, je n\'ai pas à supporter son langage. En plus, regarde ses yeux! Cet idiot était aussi aveugle qu\'une chauve-souris.%SPEECH_OFF%Les yeux de l\'énigmatique bonhomme sont d\'un gris aveugle. Qui sait combien de temps il a passé dans ce temple.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon. Deux des flacons sont à nous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Vous n\'avez pas de temps pour cet idiot. Vous le laissez partir et il s\'enfuit, vous écoutez ses pas qui ronronnent dans le noir comme les battements d\'une chauve-souris dans une grotte qui vous est familière. Il ne faut pas longtemps pour l\'entendre sortir, et à peine est-il arrivé que la compagnie %companyname% l\'abat dans une série de hurlements. Lorsque vous refaites surface, vous trouvez les mercenaires en train de frapper le cadavre de l\'idiot et de voler tout ce qui a de la valeur, ce qui est principalement une pile de devinettes mal écrites.\n\n %volunteer% rit et range les flacons apparemment magiques dans l\'inventaire. Vous ordonnez aux hommes de se préparer à repartir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est quand même une réussite, tout compte fait.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.Injury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Volunteer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"volunteer",
			this.m.Volunteer != null ? this.m.Volunteer.getNameOnly() : ""
		]);
		_vars.push([
			"idiot",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.Dude = null;
	}

});

