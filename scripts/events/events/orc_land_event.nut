this.orc_land_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.orc_land";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Un cairn avec un crâne inhabituel au sommet. Peut-être un mémorial à un grand guerrier orc. Peu importe ce que cela signifie pour les peaux vertes, ce que cela signifie pour vous est simple : vous êtes sur leur territoire maintenant. | Vous tombez sur un totem en bois dans lequel sont taillées des courbes. %randombrother% pense qu\'il s\'agit de traces du ciel nocturne, peut-être de telle ou telle constellation.\n\n %randombrother2% crache et dit que tout ce que cela signifie, c\'est que vous êtes en territoire orc et que vous feriez mieux d\'y prêter attention plutôt qu\'aux lumières de la nuit. | Vous trouvez des os dans l\'herbe. La courbure des côtes est obscène - bien trop grande pour un homme. Vous vous demandez s\'il s\'agit de ceux d\'un âne, mais la découverte d\'un énorme crâne à la forme étrangement humaine confirme vos soupçons : vous êtes en territoire orc. | Des têtes humaines sur des piques. Leurs corps - sans membres - agglutinés en tas. Ils ont été découpés et mutilés. Le seul sentiment d\'humanité qu\'il leur reste sont les lambeaux de vêtements qui s\'accrochent à peine à leur chair détruite.\n\n%randombrother% s\'approche, hochant la tête.%SPEECH_ON%On est dans la merde. C\'est le territoire des orcs.%SPEECH_OFF% | Vous tombez sur le corps d\'un homme, mais pas sur sa tête. Elle n\'est plus là. Ses parties génitales ont également disparu. Et ses pieds et ses mains. Des javelots dépassent de ce qui reste, quelqu\'un ou quelque chose a transformé ce qui reste en une horrible cible d\'entraînement.\n\n En regardant attentivement les armes, %randombrother% acquiesce et se tourne vers vous.%SPEECH_ON%Des orcs, capitaine. Nous sommes sur leurs terres maintenant et, euh, il est clair qu\'ils n\'apprécient pas les intrus.%SPEECH_OFF%. | Vous trouvez un squelette brisé cloué à un arbre par une énorme hache. Il n\'y a principalement que la cage thoracique, le reste est tombé en morceaux depuis longtemps. De longues œuvres d\'art ont été sculptées dans le tronc d\'arbre.%SPEECH_ON% C\'est le territoire des peaux vertes.%SPEECH_OFF%%randombrother% parle en s\'approchant de vous. Il touche le manche de la hache, dont le poids est presque aussi solide que l\'arbre dans lequel elle est plantée.%SPEECH_ON%Il semblerait même que ce soit un territoire orc...%SPEECH_OFF%. | Vous arrivez à une pile de pierres soigneusement placées sur une petite colline. En les inspectant, vous découvrez des gravures blanches sur les pierres. Chacune d\'entre elles raconte une histoire différente, où de grandes brutes errent et font preuve d\'une violence inquiétante envers des personnages plus petits et plus minces. %randombrother% rigole devant les gravures. %SPEECH_ON%C\'est de la fantaisie d\'orc - ce qu\'ils veulent faire passer pour une telle chose, de toute façon. Nous sommes les petits hommes sur ces dessins au cas où tu te poserais la question.%SPEECH_OFF% | Une bâche en cuir est trouvée accrochée à des bâtons sur une colline. Autour d\'elle, il y a les traces d\'un campement abandonné - un feu qui couve, des traces de pas fugaces, quelques débris bizarres. %randombrother% pointe du doigt tout cela.%SPEECH_ON%Leur odeur persiste encore. L\'odeur des... Orcs.%SPEECH_OFF%%randombrother2% se râcle la gorge et crache.%SPEECH_ON%Vous avez un bon nez pour ces merdes, capitaine.%SPEECH_OFF%%randombrother% hoche la tête.%SPEECH_ON% C\'est pas des conneries, pourtant. On est en territoire orc, les gars.%SPEECH_OFF% | %randombrother% s\'approche d\'une pile de crânes humains que vous avez croisés. Il analyse leurs blessures mortelles - principalement le fait que leurs corps ne sont nulle part en vue, la décapitation est une sacrée chose à laquelle il faut survivre. Se relevant, il hoche la tête. %SPEECH_ON%Un travail d\'orcs, les gars. Étudiez-le de près de peur de rejoindre la galerie. %SPEECH_OFF%Vous hochez également la tête et dites aux hommes d\'être conscients des dangers qui les attendent. | Il y a un sentiment pour la nature sauvage et un sentiment pour la civilisation - et ce que vous avez ici ne correspond à aucun des deux. Vous avez une sensation étrange, comme si vous veniez de vous introduire sur le territoire de quelqu\'un d\'autre. Un horrible tas de cadavres dépourvus de toute humanité aide également à faire la distinction, et à établir le simple fait que vous avez maintenant pénétré sur les terres orques.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Be on your guard.",
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
		if (this.World.getPlayerRoster().getSize() < 2)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.getTile().getDistanceTo(myTile) <= 10)
			{
				return;
			}
		}

		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();
		local num = 0;

		foreach( s in orcs )
		{
			if (s.getTile().getDistanceTo(myTile) <= 8)
			{
				num = ++num;
			}
		}

		if (num == 0)
		{
			return;
		}

		this.m.Score = 20 * num;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

