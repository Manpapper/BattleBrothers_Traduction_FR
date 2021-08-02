this.dead_bodies_on_road_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.dead_bodies_on_road";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img] {Un chariot, renversé. Des chevaux morts à ses côtés. Un âne mort qui semble s\'être battu. Des femmes. Des enfants. Quelques hommes âgés. La plupart mutilés d\'une manière inadaptée pour être trouvés par quiconque, mais vous pensez que votre compagnie était probablement la plus apte à tomber sur de telles ruines. Vous avez l\'estomac pour ça, car vous avez créé pire. C\'est l\'innocence des morts qui vous retourne les tripes, cependant, et dans un faible effort pour rectifier cette maladie morale, vous allez de l\'avant et enterrez les morts. Malheureusement, on ne trouve rien de valeur dans leurs restes. | Du sang dans le fossé au bord de la route. Du sang partout sur la route. Du sang dans le fossé de l\'autre côté de la route. Du sang sur la toile du wagon. Du sang dans les yeux des morts et du sang dans leur bouche. Un pauvre fermier, décédé, apparemment happé par une bande de voleurs car rien de ce qu\'il portait n\'est resté dans la ruine sur laquelle vous êtes tombés. | Les oiseaux ont été le premier indice : ils tournaient et retournaient au dessus d\'une catastrophe lointaine. Vous avez pensé que ce qu\'ils voyaient était encore vivant, mais le temps que vous y arriviez, le groupe s\'était posé et vous êtes tombé sur un homme mort adossé à un poteau.\n\nVous essayez de faire fuir les oiseaux. Les buses noires ne font que faire quelques pas dans la direction opposée où elles se retournent pour vous fixer. Le cadavre est frais, les moyens de sa mort ont été lents : quelques flèches ont été plantées dans son flanc. Une corde sur sa hanche suggère qu\'il avait un sac à main à cet endroit. Quelqu\'un l\'a volé - deux fois. | Vous tombez sur quelques criminels pendus. Ils se balancent à un arbre au bord de la route, leurs visages ne sont que des silhouettes sous les sacs de laine qui recouvrent leurs têtes. Quelques-uns d\'entre eux montrent des signes de torture : des entailles ici et là, les muscles éclatants devenant violets et certains déjà gris. Du sang sous les pieds d\'un homme, suggérant que quelqu\'un s\'en est pris à lui pendant qu\'il suffoquait. Naturellement, ils n\'ont rien de valeur et vous reprenez la route. | Une chèvre avec une cloche dans les bras d\'un berger mort. Vous avez trouvé le duo sur le bord de la route. La gorge de l\'animal est ouverte, et le corps de l\'homme n\'a aucune blessure. Il est peut-être mort d\'un cœur brisé. %randombrother% fouille les poches du mort et revient les mains vides. Vous décidez de laisser les deux corps là où ils étaient. | Deux buses se battent entre elles pour un morceau d\'intestin, le dévorant lentement jusqu\'à ce que leurs becs s\'entrechoquent. Vous vous seriez amusé si vous n\'aviez pas vu d\'où venait ce repas : un enfant mort, allongé face contre terre. Le dos a été arraché, une cage thoracique luisant au soleil.\n\n Vous effrayez les oiseaux - bien qu\'ils aient du mal a être effrayés - puis vous enterrez le corps. En retournant sur la route, vous voyez les deux oiseaux accroupis au-dessus de la tombe, en train de ramasser et de remuer la terre... {dans une sorte d\'angoisse aviaire | comme s\'ils voulaient recréer le processus qu\'ils avaient vu, mais en sens inverse.}. Abandonnant, ils finissent par prendre leur envol et tournent au-dessus de votre groupe d\'hommes pendant un ou deux kilomètres avant de se diriger ailleurs. | Les feux crépitent et éclatent alors qu\'ils consument le dernier wagon. %randombrother% fouille dans le désordre noirci, mais revient les mains vides. On peut trouver quelques mains qui dépassent de la cendre et de la suie, leurs formes étant également noires. Les corps ont complètement disparu, enterrés, brûlés ou enfouis sous ce qui a été brûlé. Comme il n\'y a rien à sauver, vous remettez rapidement la compagnie sur la route. | Un cheval mort. Son cavalier est de l\'autre côté de la route, ayant rampé jusqu\'à sa dernière demeure. Des flèches brisées jonchent le chemin, leurs têtes ont été arrachées et récupérées. L\'homme n\'a pas de cuir chevelu, la calotte de sa tête est rouge et brillante. Après une rapide recherche, vous réalisez qu\'il n\'y a rien à prendre ici et décidez de partir. | Vous tombez sur un tas de corps nus au bord de la route. Certains d\'entre eux ont l\'air effroyable, comme s\'ils étaient morts depuis très longtemps, bien qu\'il y ait du sang plutôt frais dans certaines de leurs bouches. Quelques-uns des cadavres portent de la couleur dans leur chair, mais ils ont ce qui ressemble à des marques de morsure ici et là. Des mesures préventives ont été prises, semble-t-il, car chacun d\'entre eux a eu le cou tranché. Nus comme ils le sont, vous ne trouvez naturellement rien sur eux. Vous passez à autre chose. | Vous avez l\'impression d\'être dévisagé et vous vous arrêtez, vous tournant rapidement sur le côté de la route avec une main sur votre épée. Une tête vous regarde fixement, ses yeux dépassant à peine de l\'herbe. %randombrother% s\'approche et la ramasse. Le visage porte le visage d\'une mort plutôt choquante, étant si détendu et incliné. Vous dites au mercenaire de poser la tête, vous avez mieux à faire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reposez en paix.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			if (s.getTile().getDistanceTo(myTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

